$ = require("jquery")
Bacon = require("baconjs")
storage = require("./storage.coffee")

module.exports = (shareE) ->
  $dialog = $("#file-share-dialog")
  url = document.location.toString()
  $dialog.find("#share-link").text(url).attr("href", url)
  shareE.onValue ->
    $dialog.addClass "active"

  dismissE = $dialog.asEventStream("click").doAction(".stopPropagation")
  dismissE.onValue -> $dialog.removeClass("active")
