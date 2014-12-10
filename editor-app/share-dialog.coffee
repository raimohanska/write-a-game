$ = require("jquery")
Bacon = require("baconjs")
storage = require("./storage.coffee")

module.exports = (applicationP, shareE) ->
  $dialog = $("#file-share-dialog")
  applicationP.onValue ({author, name}) ->
    url = storage.applicationUrl(author, name)
    $dialog.find("#share-link").text(url).attr("href", url)
  shareE.onValue ->
    $dialog.addClass "active"

  dismissE = $dialog.asEventStream("click").doAction(".stopPropagation")
  dismissE.onValue -> $dialog.removeClass("active")
