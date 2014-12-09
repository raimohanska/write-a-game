Bacon = require("baconjs")
$ = require("jquery")

Editor = (initialApplication) ->
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
  codeMirror.setValue(initialApplication.code)
  codeP = Bacon.fromEventTarget(codeMirror, "change")
    .map(".getValue")
    .toProperty(initialApplication.code)

  codeMirror.focus()

  { codeP, runE: runBus, codeMirror }

module.exports = Editor