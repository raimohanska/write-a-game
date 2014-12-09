$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
examples = require("./examples.coffee")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")
Editor = require("./editor.coffee")
ErrorDisplay = require("./error-display.coffee")

$run = $(".run")

runBus = new Bacon.Bus()

initialApplication = if localStorage.application 
    JSON.parse(localStorage.application) 
  else
    examples.first

enabledP = Bacon.constant(true)

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

codeP = editor.codeP

applicationP = Bacon.combineTemplate
  name: "some app"
  code: codeP
  assets: assetsP

evalE = applicationP
  .filter(enabledP)
  .sampledBy($run.asEventStream("click").doAction(".preventDefault").merge(runBus))

evalResultE = evalE.flatMap (application) ->
  resultBus = new Bacon.Bus()
  window.frameLoaded = (frame) ->
    try
      assetsJs = "window.assets=" + JSON.stringify(application.assets) + ";"
      frame.eval(assetsJs)
      frame.eval(application.code)
      resultBus.push "success"
    catch e
      resultBus.error e
  $("#game").attr("src", "game/game.html")
  resultBus

ErrorDisplay(editor.codeMirror, evalResultE)

evalResultE.onValue ->

AssetListView(assetsP)

applicationP.onValue (application) ->
  localStorage.application = JSON.stringify(application)

$("body").css("opacity", 1)
