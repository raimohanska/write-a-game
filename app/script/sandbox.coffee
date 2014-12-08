_ = require("lodash")
Sandbox = ->
  iframe = document.createElement("iframe")
  iframe.style.display = "none"
  document.body.appendChild iframe
  frame = window.frames[window.frames.length - 1]
  eval: (code) ->
    frame.eval code

  setGlobals: (env) ->
    _.extend(frame, env)

module.exports = Sandbox
