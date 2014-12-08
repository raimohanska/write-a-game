$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
Figure = require("./figure.coffee")

interval = (i, fn) -> setInterval fn, i

globals = { Figure, $, _, interval }

_.extend(window, globals)

window.parent.frameLoaded(window)
