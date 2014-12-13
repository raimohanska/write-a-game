Bacon = require("baconjs")

module.exports = (application) ->
  focusFrame = ->
    $frame.get(0).contentWindow.focus()
  $frame = $("#game")
  resultBus = new Bacon.Bus()
  window.frameLoaded = (frame) ->
    try
      assetsJs = "window.assets=" + JSON.stringify(application.assets) + ";"
      frame.eval(assetsJs)
      frame.eval(application.code)
      resultBus.push "success"
      setTimeout focusFrame, 0
    catch e
      resultBus.error e
  $frame.attr("src", "/game/game.html")
  resultBus

