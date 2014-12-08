$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
sandbox = require("./sandbox.coffee")()

$code = $("#code")
$header = $("#assignment .heading")
$run = $("#assignment .run")

codeMirror = CodeMirror.fromTextArea $code.get(0), { 
  lineNumbers: true
  mode: "javascript"
  theme: "solarized dark"
}
codeP = Bacon.fromEventTarget(codeMirror, "change")
  .map(".getValue")
  .toProperty(code)
enabledP = Bacon.constant(true)

evalE = codeP.filter(enabledP).sampledBy($run.asEventStream("click").doAction(".preventDefault"))

evalCode = (code) -> sandbox.eval("(" + code + ")")

evalE.onValue(evalCode)
