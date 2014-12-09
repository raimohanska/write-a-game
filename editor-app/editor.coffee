Bacon = require("baconjs")
$ = require("jquery")

Editor = (initialCode, codeLoadedE) ->
  runBus = new Bacon.Bus()
  $code = $("#code #editor")
  codeMirror = CodeMirror.fromTextArea $code.get(0), {
    lineNumbers: true
    mode: "javascript"
    theme: "solarized dark",
    extraKeys: {
      "Ctrl-Enter": -> runBus.push()
    }
  }
  codeMirror.setValue(initialCode)
  codeLoadedE.onValue(codeMirror, "setValue")
  codeP = Bacon.fromEventTarget(codeMirror, "change")
    .map(".getValue")
    .toProperty(initialCode)

  codeMirror.focus()

  { codeP, runE: runBus, codeMirror }

module.exports = Editor
