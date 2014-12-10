Bacon = require("baconjs")

module.exports = (loginE, logoutE) ->
  initialAuthor = localStorage.author
  authorP = Bacon.update(initialAuthor,
    loginE, -> prompt("What's your name?")
    logoutE, -> "")
  authorP.onValue (author) -> localStorage.author = author
  { authorP, loggedInP: authorP.map((a) -> !!a) }
    
