$ = require("jquery")
Bacon = require("baconjs")
_ = require("lodash")
examples = require("./examples.coffee")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")
Editor = require("./editor.coffee")
ErrorDisplay = require("./error-display.coffee")
runCode = require("./code-runner.coffee")
menubar = require("./menu.coffee")
storage = require("./storage.coffee")
Author = require("./author.coffee")
ShareDialog = require("./share-dialog.coffee")
StatusView = require("./status-view.coffee")
FileOperations = require("./file-operations.coffee")
showStatusMessage = require("./status-message.coffee")

module.exports = (initialApplication, fromRemote) ->
  assetsP = Bacon.update initialApplication.assets,
    assetUploader.newAssetE, (assets, newFile) ->
      assets = _.clone(assets)
      assets[newFile.name] = newFile
      assets
    assetUploader.removeAssetE, (assets, asset) ->
      assets = _.clone(assets)
      delete assets[asset.name]
      assets

  editor = Editor(initialApplication.code)

  # Login / logout
  logoutE = menubar.itemClickE("file-logout")
  logoutE.map("Logged out").onValue(showStatusMessage)
  author = Author(menubar.itemClickE("file-login"), logoutE)
  author.authorP.changes().filter(author.loggedInP).map((author) -> "Logged in as \"" + author + "\"")
    .onValue(showStatusMessage)

  # Application property
  applicationP = Bacon.combineTemplate
    code: editor.codeP
    assets: assetsP

  # Running
  evalE = applicationP
    .sampledBy($(".run").asEventStream("click").doAction(".preventDefault").merge(editor.runE))
  evalResultE = evalE.flatMap runCode

  ErrorDisplay(editor.codeMirror, evalResultE)

  AssetListView(assetsP)

  ShareDialog(menubar.itemClickE("file-share"))

  # Saving
  applicationP.changes().onValue storage.storeLocally
  saveE = menubar.itemClickE("file-save")
  saveResultE = saveE
    .map(Bacon.combineTemplate({app: applicationP, author: author.authorP}))
    .flatMap ({app, author}) ->
      storage.save(app, author, initialApplication.name)
  saveResultE
    .map("Saved succesfully")
    .onValue(showStatusMessage)
  
  if not fromRemote
    firstSaveE = saveResultE.take(1)
    firstSaveE.map(author.authorP)
      .onValue (author) -> storage.open(author, initialApplication.name)

  StatusView(initialApplication, fromRemote, applicationP.changes(), saveResultE, author)
  
  newE = menubar.itemClickE("file-new")
  openE = menubar.itemClickE("file-open")
  forkE = menubar.itemClickE("file-fork")
  renameE = menubar.itemClickE("file-rename")

  FileOperations(author, initialApplication, newE, openE, forkE, renameE)

  $("#menu-file > .title").text('Project "' + initialApplication.name + '"')

  $("body").css("opacity", 1)
