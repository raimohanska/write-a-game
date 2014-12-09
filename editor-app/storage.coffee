module.exports = (applicationP, saveE, saveCopyE) ->
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
  { saveResultE }
