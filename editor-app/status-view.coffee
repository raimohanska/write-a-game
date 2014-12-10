module.exports = (initialApplication, fromRemote, changeE, saveResultE, author) ->
  hasRemoteP = Bacon.constant(fromRemote)

  isOwnerP = author.authorP.map (author) ->
    !initialApplication.author || initialApplication.author is author

  dirtyP = changeE.map(true)
    .merge(saveResultE.map(false))
    .toProperty(false)
    .or(hasRemoteP.not())

  author.loggedInP.onValue (loggedIn) ->
    $("body").toggleClass("logged-in", loggedIn)

  dirtyP.onValue (dirty) ->
    $("body").toggleClass("dirty", dirty)


  if fromRemote
    $("body").addClass("remote")
    dirtyP.not().onValue (saved) ->
      $("body").toggleClass("saved", saved)
  
  isOwnerP.onValue (owner) ->
    $("body").toggleClass("is-owner", owner)
