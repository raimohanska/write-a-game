$ = require("jquery")
Bacon = require("baconjs")
_ = require("lodash")
examples = require("./examples.coffee")
Editor = require("./editor.coffee")
ErrorDisplay = require("./error-display.coffee")
runCode = require("./code-runner.coffee")
menubar = require("./menu.coffee")
Author = require("./author.coffee")
Assets = require("./assets.coffee")
ShareDialog = require("./share-dialog.coffee")
StatusView = require("./status-view.coffee")
FileOperations = require("./file-operations.coffee")
showStatusMessage = require("./status-message.coffee")

module.exports = (initialApplication, fromRemote) ->
  logoutE = menubar.itemClickE("file-logout")
  author = Author(menubar.itemClickE("file-login"), logoutE)
  
  editor = Editor(initialApplication.code)

  applicationP = Bacon.combineTemplate
    code: editor.codeP
    assets: Assets(initialApplication).assetsP

  evalE = applicationP
    .sampledBy($(".run").asEventStream("click").doAction(".preventDefault").merge(editor.runE))
  evalResultE = evalE.flatMap runCode

  newE = menubar.itemClickE("file-new")
  openE = menubar.itemClickE("file-open")
  forkE = menubar.itemClickE("file-fork")
  renameE = menubar.itemClickE("file-rename")
  saveE = menubar.itemClickE("file-save")

  fileOps = FileOperations(author, initialApplication, fromRemote, applicationP, newE, openE, forkE, renameE, saveE)
  
  fileOps.saveResultE.map("Saved succesfully").onValue(showStatusMessage)
  logoutE.map("Logged out").onValue(showStatusMessage)
  author.authorP.changes().filter(author.loggedInP)
    .map((author) -> "Logged in as \"" + author + "\"")
    .onValue(showStatusMessage)
  
  ErrorDisplay(editor.codeMirror, evalResultE)
  ShareDialog(menubar.itemClickE("file-share"))
  StatusView(initialApplication, fromRemote, applicationP.changes(), fileOps.saveResultE, author)
  
  $("#menu-file > .title").text('Project "' + initialApplication.name + '"')

  $("body").css("opacity", 1)
