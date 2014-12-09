$=require("jquery")

module.exports = (message) ->
  $message = $("#statusbar .message")
  $message
    .text(message)
    .addClass("active")
  setTimeout((-> $message.removeClass("active")), 1000)
