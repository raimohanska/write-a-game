module.exports = (applicationP, saveE, saveCopyE, renameE) ->
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
    .flatMap (request) ->
      Bacon.fromPromise($.ajax(request))
    .map("Renamed succesfully")
    
  { saveResultE, renameResultE }
