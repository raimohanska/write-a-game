Bacon = require("baconjs")
_ = require("lodash")

storage = module.exports =
  storeLocally: (application) ->
    localStorage.application = JSON.stringify(application)
  newApplication: ->
    delete localStorage.application
    document.location.pathname = "/"
  applicationUrl: (author, name) ->
    document.location.origin + "/projects/" + author + "/" + name
  open: (author, name) ->
    document.location = module.exports.applicationUrl(author, name)
  ajaxOpen: (author, name) ->
    Bacon.fromPromise($.ajax("/apps/" + author + "/" + name))
  save: (application, author, name) ->
    application = _.clone(application)
    application.name = name
    application.author = author
    request =
      url: "/apps"
      type: "post"
      contentType: "application/json"
      data: JSON.stringify(application)
    Bacon.fromPromise($.ajax(request))

  fork: (application, author, name) ->
    storage.save(application, author, name)
      .onValue(-> storage.open author, name)

  rename: (author, oldName, newName) ->
    request =
      url: "/apps/" + author + "/" + oldName + "/rename/" + newName
      type: "post"
    Bacon.fromPromise($.ajax(request))
      .onValue -> storage.open author, newName
