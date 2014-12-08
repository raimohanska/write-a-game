$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
examples = require("./examples.coffee")

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
initialCode = localStorage.code || examples.first
codeMirror.setValue(initialCode)
codeP = Bacon.fromEventTarget(codeMirror, "change")
  .map(".getValue")
  .toProperty(initialCode)
enabledP = Bacon.constant(true)

codeP.onValue (code) -> 
  localStorage.code = code

evalE = codeP.filter(enabledP).sampledBy($run.asEventStream("click").doAction(".preventDefault").merge(runBus))

evalCode = (code) -> 
  window.frameLoaded = (frame) ->
    frame.eval(code)
  $("#game").attr("src", "game.html")

evalE.onValue(evalCode)

codeMirror.focus()
$("body").css("opacity", 1)
