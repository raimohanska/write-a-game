$ = window.$ = require("jquery")
Bacon = window.Bacon = require("baconjs")
Bacon.Observable :: flatScan = (seed, f) ->
  acc = seed
  @flatMapLatest((newValue) ->
    acc = f(acc, newValue)
  )
  .toProperty(seed)
_ = require("lodash")
$.fn.asEventStream = Bacon.$.asEventStream
App = require("./app.coffee")
KiRouter = require("ki-router.js")
storage = require("./storage.coffee")

router = KiRouter.router()
router.add "/", -> 
  initialApplication = if localStorage.application
      JSON.parse(localStorage.application)
    else
      examples.first
  App(initialApplication)
router.add "/projects/:author/:name", (params) ->
  openE = storage.openE(params.author, params.name)
  openE.onValue App
  openE.onError -> showError 404, "Not found"

showError = alert

router.renderInitialView()
