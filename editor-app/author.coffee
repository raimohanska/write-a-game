Bacon = require("baconjs")

module.exports = (initialAuthor, loginE, logoutE) ->
  console.log initialAuthor
  authorP = Bacon.update(initialAuthor,
    loginE, -> prompt("What's your name?")
    logoutE, -> undefined)
  { authorP, loggedInP: authorP.map((a) -> !!a) }
    
