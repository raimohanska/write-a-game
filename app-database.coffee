AppDatabase = (mongoUrl, app) ->
  MongoClient.connect mongoUrl, (err, conn) ->
    if err
      console.log "ERROR: cannot connect to mongo at ", mongoUrl, err
    else
      AppDatabaseWithConnection conn, app
    return

  return
AppDatabaseWithConnection = (conn, app) ->
  mongoPost = (content) ->
    data =
      author: content.author
      name: content.name
      code: JSON.stringify(content.code)
      assets: JSON.stringify(content.assets)
      date: new Date()

    Bacon.fromNodeCallback(apps, "update",
      author: data.author
      name: data.name
    , data,
      upsert: true
    ).map data
  mongoFind = (query, projection) ->
    Bacon.fromNodeCallback apps.find(query, projection).sort(date: -1), "toArray"
  sendResult = (resultE, res) ->
    resultE.onError (err) ->
      console.log "Mongo error", err
      res.send err
      return

    resultE.onValue (value) ->
      if value
        value.code = JSON.parse(value.code) if value.code?
        value.assets = JSON.parse(value.assets) if value.assets?
        res.json value
      else
        res.status(404).send "Not found"
      return

    return
  apps = conn.collection("apps")
  app.get "/apps", (req, res) ->
    sendResult mongoFind({},
      author: true
      name: true
    ), res
    return

  app.get "/apps/:author", (req, res) ->
    sendResult mongoFind(
      author: req.params.author
    ,
      name: true
    ), res
    return

  app.get "/apps/:author/:name", (req, res) ->
    sendResult mongoFind(
      author: req.params.author
      name: req.params.name
    , {}).map(".0"), res
    return

  app.post "/apps", (req, res) ->
    sendResult mongoPost(req.body), res
    return

  app.post "/apps/:author/:name/rename/:newName", (req, res) ->
    mongoResult = Bacon.fromNodeCallback(apps, "update",
      author: req.params.author
      name: req.params.name
    ,
      $set:
        name: req.params.newName
    )
    sendResult mongoResult, res
    return

  return
Bacon = require("baconjs")
randomstring = require("randomstring")
MongoClient = require("mongodb").MongoClient
module.exports = AppDatabase
