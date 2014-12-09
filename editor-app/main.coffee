$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
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
FileOpener = require("./file-opener.coffee")

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

editor = Editor(initialApplication)

author = Author(initialApplication.author, menubar.itemClickE("file-login"), menubar.itemClickE("file-logout"))

fileLoadedE = FileOpener(author.authorP, menubar.itemClickE("file-open")).fileLoadedE
fileLoadedE.log()

applicationP = Bacon.combineTemplate
  author: author.authorP
  name: "some app"
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
  menubar.itemClickE("file-save-copy")
)


author.authorP.log()
author.loggedInP.onValue (loggedIn) ->
  $(".menu .loggedin").toggleClass("disabled", !loggedIn)


storage.saveResultE.log()

$("body").css("opacity", 1)
