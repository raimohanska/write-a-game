$ = require("jquery")
Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
_.extend(window, { $, _, Bacon })

Figure = require("./figure.coffee")
Keyboard = require("./keyboard.coffee")
interval = (i, fn) -> setInterval fn, i
background = (bg) -> $("#game").css("background", bg)

_.extend(window, { Figure, Keyboard, interval, background })

window.parent.frameLoaded(window)
