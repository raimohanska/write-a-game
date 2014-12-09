module.exports = (applicationP, saveE, renameE) ->
  saveResultE = saveE
    .map applicationP
    .map (application) -> {
        url: "/apps"
        type: "post"
        contentType: "application/json"
        data: JSON.stringify(application)
      }
    .flatMap (request) ->
      Bacon.fromPromise($.ajax(request))
    .map("Saved succesfully")

  renameResultE = renameE
    .combine(applicationP.map(".author"), ({oldName, newName}, author) -> {
        url: "/apps/" + author + "/" + oldName + "/rename/" + newName
        type: "post"
      })
    .sampledBy(renameE)
    .flatMap (request) ->
      Bacon.fromPromise($.ajax(request))
    .map("Renamed succesfully")
    
  { saveResultE, renameResultE }
