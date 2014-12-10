storage = require("./storage.coffee")
FileDialog = require("./file-dialog.coffee")

module.exports = (author, initialApplication, fromRemote, applicationP, newE, openE, forkE, renameE, saveE) ->
  newE.onValue storage.newApplication

  FileDialog(author.authorP, openE)
  
  promptNewName = (suggestion) ->
    newName = prompt("Enter new name", suggestion) || suggestion
    Bacon.once(newName)

  forkE
    .flatMap ->
      promptNewName(initialApplication.name + " fork")
    .flatMap (name) ->
      Bacon.combineTemplate({ name, author: author.authorP, application: applicationP }).take(1)
    .onValue ({application, author, name}) ->
      storage.fork(application, author, name)

  renameE
    .flatMap(-> promptNewName(initialApplication.name))
    .map (newName) -> { newName, oldName: initialApplication.name }
    .combine(author.authorP, ({oldName, newName}, author) -> [ author, oldName, newName])
    .onValues(storage.rename)

  applicationP.changes().onValue storage.storeLocally

  saveResultE = saveE
    .map(Bacon.combineTemplate({app: applicationP, author: author.authorP}))
    .flatMap ({app, author}) ->
      storage.save(app, author, initialApplication.name)

  if not fromRemote
    firstSaveE = saveResultE.take(1)
    firstSaveE.map(author.authorP)
      .onValue (author) -> storage.open(author, initialApplication.name)

  { saveResultE }

