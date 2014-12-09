Bacon = require("baconjs")
$ = require("jquery")

Editor = (initialApplication) ->
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

  { codeP, codeMirror }

module.exports = Editor
