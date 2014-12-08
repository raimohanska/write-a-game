parseLineNumber = (stack) ->
  stackLines = stack.split("\n")
  for i of stackLines
    line = stackLines[i]
    match = line.match(/\d+:\d+/g)
    if match
      parsed = match[match.length - 1].match(/\d+/g)
      return parseInt(parsed[0])
  return
parseStack = (error) ->
  return null  if typeof error.stack isnt "string"
  message: error.message
  lineNumber: parseLineNumber(error.stack)

module.exports = parseStack
