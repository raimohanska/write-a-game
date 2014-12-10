examples = require("./examples.coffee")
$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
App = require("./app.coffee")
KiRouter = require("ki-router.js")
storage = require("./storage.coffee")

router = KiRouter.router()
router.add "/", -> 
  if localStorage.application
    App(JSON.parse(localStorage.application), false)
  else
    App(examples.first, false)
router.add "/projects/:author/:name", (params) ->
  openE = storage.ajaxOpen(params.author, params.name)
  openE.onValue (app) -> App(app, true)
  openE.onError -> showError 404, "Not found"

showError = alert

router.renderInitialView()
