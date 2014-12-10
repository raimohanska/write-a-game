Bacon = require("baconjs")

module.exports =
  openE: (author, name) ->
    Bacon.fromPromise($.ajax("/apps/" + author + "/" + name))
  saveResultE : (applicationP, saveE) ->
    saveE.map applicationP
    .map (application) -> {
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
