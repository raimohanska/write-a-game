$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
examples = require("./examples.coffee")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")

$code = $("#code #editor")
$run = $(".run")

runBus = new Bacon.Bus()

codeMirror = CodeMirror.fromTextArea $code.get(0), {
  lineNumbers: true
  mode: "javascript"
  theme: "solarized dark",
  extraKeys: {
    "Ctrl-Enter": -> runBus.push()
  }
}
initialApplication = if localStorage.application 
    JSON.parse(localStorage.application) 
  else 
    examples.first
codeMirror.setValue(initialApplication.code)
codeP = Bacon.fromEventTarget(codeMirror, "change")
  .map(".getValue")
  .toProperty(initialApplication.code)
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

applicationP = Bacon.combineTemplate
  name: "some app"
  code: codeP
  assets: assetsP

evalE = applicationP
  .filter(enabledP)
  .sampledBy($run.asEventStream("click").doAction(".preventDefault").merge(runBus))

$error = $("#code .error")
parseStack = require("./parse-stack.coffee")
errorDisplay = require("./error-display.coffee")(codeMirror, $error)

evalCode = (application) -> 
  window.frameLoaded = (frame) ->
    try
      assetsJs = "window.assets=" + JSON.stringify(application.assets) + ";"
      frame.eval(assetsJs)
      frame.eval(application.code)
      errorDisplay.clearError()
    catch e
      errorDisplay.showError(parseStack(e))
  $("#game").attr("src", "game/game.html")

evalE.onValue(evalCode)

AssetListView(assetsP)

applicationP.onValue (application) ->
  localStorage.application = JSON.stringify(application)

codeMirror.focus()
$("body").css("opacity", 1)
