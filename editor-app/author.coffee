Bacon = require("baconjs")

module.exports = (initialAuthor, loginE) ->
  console.log initialAuthor
  authorP = loginE
    .map -> prompt("What's your name?")
    .toProperty(initialAuthor)
  { authorP, loggedInP: authorP.map((a) -> !!a) }
    
