Bacon = require("baconjs")

module.exports = (application) ->
  resultBus = new Bacon.Bus()
  window.frameLoaded = (frame) ->
    try
      assetsJs = "window.assets=" + JSON.stringify(application.assets) + ";"
      frame.eval(assetsJs)
      frame.eval(application.code)
      resultBus.push "success"
    catch e
      resultBus.error e
  $("#game").attr("src", "/game/game.html")
  resultBus

