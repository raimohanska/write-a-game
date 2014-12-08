$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
Figure = require("./figure.coffee")

interval = (i, fn) -> setInterval fn, i
background = (bg) -> $("#game").css("background", bg)

globals = { Figure, $, _, interval, background }

_.extend(window, globals)

window.parent.frameLoaded(window)
