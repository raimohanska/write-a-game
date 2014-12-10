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

module.exports = (initialApplication) ->
  fileLoadedBus = new Bacon.Bus()
  assetsP = Bacon.update initialApplication.assets,
    assetUploader.newAssetE, (assets, newFile) ->
      assets = _.clone(assets)
      assets[newFile.name] = newFile
      assets
    assetUploader.removeAssetE, (assets, asset) ->
      assets = _.clone(assets)
      delete assets[asset.name]
      assets
    fileLoadedBus.map(".assets"), (_, loadedAssets) ->
      loadedAssets

  editor = Editor(initialApplication.code, fileLoadedBus.map(".code"))

  logoutE = menubar.itemClickE("file-logout")
  author = Author(menubar.itemClickE("file-login"), logoutE)

  logoutE.map("Logged out").onValue(showStatusMessage)
  author.authorP.changes().filter(author.loggedInP).map((author) -> "Logged in as \"" + author + "\"")
    .onValue(showStatusMessage)

  fileDialog = FileDialog(author.authorP, menubar.itemClickE("file-open"))
  fileDialog.fileLoadedE.map((app) -> "Loaded \"" + app.name + "\"").onValue(showStatusMessage)
  fileLoadedBus.plug(fileDialog.fileLoadedE)
  fileLoadedBus.plug(menubar.itemClickE("file-new").map(examples.empty))

  nameModE = fileLoadedBus.map((app) -> (-> {name: app.name}))
    .merge(menubar.itemClickE("file-rename").map(-> ({name}, newName) ->
       promptNewName(name).map((newName) -> {name: newName, rename: true, oldName: name})
     ))

  nameChangesP = nameModE.flatScan(initialApplication, (oldName, f) -> f(oldName))
  nameP = nameChangesP.map(".name")

  renameE = nameChangesP.changes().filter(".rename").map(({name, oldName}) -> {newName: name, oldName})

  nameP.onValue (name) ->
    $("#menu-file > .title").text('Project "' + name + '"')

  applicationP = Bacon.combineTemplate
    author: author.authorP
    name: nameP
    code: editor.codeP
    assets: assetsP

  evalE = applicationP
    .sampledBy($(".run").asEventStream("click").doAction(".preventDefault").merge(editor.runE))

  evalResultE = evalE.flatMap runCode

  ErrorDisplay(editor.codeMirror, evalResultE)

  AssetListView(assetsP)

  ShareDialog(applicationP, menubar.itemClickE("file-share"))

  applicationP.changes().onValue (application) ->
    localStorage.application = JSON.stringify(application)

  saveE = menubar.itemClickE("file-save")
  
  storage.saveResultE(author.authorP, applicationP, saveE).onValue(showStatusMessage)
  storage.renameResultE(applicationP, renameE).onValue(showStatusMessage)

  promptNewName = (suggestion) ->
    newName = prompt("Enter new name", suggestion) || suggestion
    Bacon.once(newName)

  forkE = menubar.itemClickE("file-fork")
    .map(applicationP)
    .flatMap (application) ->
      promptNewName(application.name + " fork")
        .map (newName) ->
          application = _.clone(application)
          application.name = newName
          application

  fileLoadedBus.plug(forkE)

  savedP = saveE.map(true).merge(applicationP.changes().map(false)).toProperty(false)

  author.loggedInP.onValue (loggedIn) ->
    $(".menu .loggedin").toggleClass("disabled", !loggedIn)
  savedP.and(author.loggedInP).not().onValue (dirty) ->
    $("#file-share").toggleClass("disabled", dirty)

  $("body").css("opacity", 1)
