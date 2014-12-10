Bacon = require("baconjs")
_ = require("lodash")

module.exports =
  openE: (author, name) ->
    Bacon.fromPromise($.ajax("/apps/" + author + "/" + name))
  saveResultE : (authorP, applicationP, saveE) ->
    saveE.map Bacon.combineTemplate({app: applicationP, author: authorP})
    .map ({app, author}) ->
      application = _.clone(app)
      application.author = author
      {
        url: "/apps"
        type: "post"
        contentType: "application/json"
        data: JSON.stringify(application)
      }
    .flatMap (request) ->
      Bacon.fromPromise($.ajax(request))
    .map("Saved succesfully")

  renameResultE : (applicationP, renameE) ->
    renameE.combine(applicationP.map(".author"), ({oldName, newName}, author) -> {
        url: "/apps/" + author + "/" + oldName + "/rename/" + newName
        type: "post"
      })
    .sampledBy(renameE)
    .flatMap (request) ->
      Bacon.fromPromise($.ajax(request))
    .map("Renamed succesfully")
