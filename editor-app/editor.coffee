Bacon = require("baconjs")
$ = require("jquery")

Editor = (initialCode) ->
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

  codeP = Bacon.fromEventTarget(codeMirror, "change")
    .map(".getValue")
    .toProperty(initialCode)

  codeMirror.focus()

  { codeP, codeEditE: codeP.changes(), runE: runBus, codeMirror }

module.exports = Editor
