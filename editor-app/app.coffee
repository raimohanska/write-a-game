$ = require("jquery")
Bacon = require("baconjs")
_ = require("lodash")
examples = require("./examples.coffee")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")
Editor = require("./editor.coffee")
ErrorDisplay = require("./error-display.coffee")
runCode = require("./code-runner.coffee")
menubar = require("./menu.coffee")
storage = require("./storage.coffee")
Author = require("./author.coffee")
FileDialog = require("./file-dialog.coffee")
ShareDialog = require("./share-dialog.coffee")
showStatusMessage = require("./status-message.coffee")

module.exports = (initialApplication, fromRemote) ->
  assetsP = Bacon.update initialApplication.assets,
    assetUploader.newAssetE, (assets, newFile) ->
      assets = _.clone(assets)
      assets[newFile.name] = newFile
      assets
    assetUploader.removeAssetE, (assets, asset) ->
      assets = _.clone(assets)
      delete assets[asset.name]
      assets

  editor = Editor(initialApplication.code)

  logoutE = menubar.itemClickE("file-logout")
  author = Author(menubar.itemClickE("file-login"), logoutE)

  logoutE.map("Logged out").onValue(showStatusMessage)
  author.authorP.changes().filter(author.loggedInP).map((author) -> "Logged in as \"" + author + "\"")
    .onValue(showStatusMessage)

  newE = menubar.itemClickE("file-new")
  newE.onValue storage.newApplication

  fileDialog = FileDialog(author.authorP, menubar.itemClickE("file-open"))

  renameE = menubar.itemClickE("file-rename")
    .flatMap(-> promptNewName(initialApplication.name))
    .map (newName) -> { newName, oldName: initialApplication.name }

  $("#menu-file > .title").text('Project "' + initialApplication.name + '"')

  applicationP = Bacon.combineTemplate
    code: editor.codeP
    assets: assetsP

  evalE = applicationP
    .sampledBy($(".run").asEventStream("click").doAction(".preventDefault").merge(editor.runE))

  evalResultE = evalE.flatMap runCode

  ErrorDisplay(editor.codeMirror, evalResultE)

  AssetListView(assetsP)

  ShareDialog(menubar.itemClickE("file-share"))

  applicationP.changes().onValue storage.storeLocally

  saveE = menubar.itemClickE("file-save")
 
  saveResultE = saveE
    .map(Bacon.combineTemplate({app: applicationP, author: author.authorP}))
    .flatMap ({app, author}) ->
      storage.save(app, author, initialApplication.name)

  saveResultE
    .map("Saved succesfully")
    .onValue(showStatusMessage)

  renameE.combine(author.authorP, ({oldName, newName}, author) -> [ author, oldName, newName])
    .onValues(storage.rename)
    
  promptNewName = (suggestion) ->
    newName = prompt("Enter new name", suggestion) || suggestion
    Bacon.once(newName)

  forkE = menubar.itemClickE("file-fork")
    .flatMap ->
      promptNewName(initialApplication.name + " fork")
    .flatMap (name) ->
      Bacon.combineTemplate({ name, author: author.authorP, application: applicationP }).take(1)

  forkE.onValue ({application, author, name}) ->
    storage.fork(application, author, name)

  changedByUser = applicationP.changes()
  hasRemoteP = saveResultE.map(true)
    .toProperty(fromRemote)

  firstSaveE = hasRemoteP.changes().filter((x) -> x)
  firstSaveE.map(author.authorP)
    .onValue (author) -> storage.open(author, initialApplication.name)

  isOwnerP = author.authorP.map (author) ->
    !initialApplication.author || initialApplication.author isnt author

  dirtyP = changedByUser.map(true)
    .merge(saveResultE.map(false))
    .toProperty(false)
    .or(hasRemoteP.not())

  author.loggedInP.onValue (loggedIn) ->
    $("body").toggleClass("logged-in", loggedIn)

  dirtyP.onValue (dirty) ->
    $("body").toggleClass("dirty", dirty)

  hasRemoteP.onValue (remote) ->
    $("body").toggleClass("remote", remote)
  
  hasRemoteP.onValue (remote) ->
    $("body").toggleClass("remote", remote)

  hasRemoteP.and(dirtyP.not()).onValue (saved) ->
    $("body").toggleClass("saved", saved)
  
  isOwnerP.onValue (owner) ->
    $("body").toggleClass("is-owner", owner)

  $("body").css("opacity", 1)
