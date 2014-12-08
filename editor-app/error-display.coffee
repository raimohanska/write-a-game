module.exports = (codeMirror, errorElement) ->
  errorLine = undefined

  showErrorText = (text) -> errorElement.text(text)

  clearError = ->
    showErrorText ""
    if errorLine isnt `undefined`
      codeMirror.removeLineClass errorLine, "gutter", "line-error"
      errorLine = `undefined`
  showError = (error) ->
    error.lineNumber = `undefined`  if error.lineNumber > codeMirror.lineCount()
    if error.lineNumber
      errorLine = error.lineNumber - 1
      codeMirror.addLineClass errorLine, "gutter", "line-error"
      showErrorText "Error on line " + error.lineNumber + ": " + error.message
    else
      showErrorText "Error: " + error.message

  { clearError, showError }

