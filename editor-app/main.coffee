$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
Bacon.Observable :: flatScan = (seed, f) ->
  acc = seed
  @flatMapLatest((newValue) ->
    acc = f(acc, newValue)
  )
  .toProperty(seed)
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
examples = require("./examples.coffee")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")
Editor = require("./editor.coffee")
ErrorDisplay = require("./error-display.coffee")
runCode = require("./code-runner.coffee")
menubar = require("./menu.coffee")
Storage = require("./storage.coffee")
Author = require("./author.coffee")
FileDialog = require("./file-dialog.coffee")
showStatusMessage = require("./status-message.coffee")

fileLoadedBus = new Bacon.Bus()
initialApplication = if localStorage.application
    JSON.parse(localStorage.application)
  else
    examples.first

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
author = Author(initialApplication.author, menubar.itemClickE("file-login"), logoutE)

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

applicationP.onValue (application) ->
  localStorage.application = JSON.stringify(application)

storage = Storage(
  applicationP,
  menubar.itemClickE("file-save")
  renameE
)
storage.saveResultE.onValue(showStatusMessage)
storage.renameResultE.onValue(showStatusMessage)

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

author.loggedInP.onValue (loggedIn) ->
  $(".menu .loggedin").toggleClass("disabled", !loggedIn)

$("body").css("opacity", 1)
