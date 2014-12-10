$ = require("jquery")
Bacon = require("baconjs")

module.exports = (applicationP, shareE) ->
  $dialog = $("#file-share-dialog")
  applicationP.onValue ({author, name}) ->
    url = document.location.origin + "/projects/" + author + "/" + name
    $dialog.find("#share-link").text(url).attr("href", url)
  shareE.onValue ->
    $dialog.addClass "active"

  dismissE = $dialog.asEventStream("click").doAction(".stopPropagation")
  dismissE.onValue -> $dialog.removeClass("active")
