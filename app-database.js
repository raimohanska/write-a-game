var Bacon = require("baconjs")
var randomstring = require("randomstring")
var MongoClient = require('mongodb').MongoClient

function AppDatabase(mongoUrl, app) {
  MongoClient.connect(mongoUrl, function(err, conn) {
    if (err) {
      console.log("ERROR: cannot connect to mongo at ", mongoUrl, err)
    } else {
      AppDatabaseWithConnection(conn, app)
    }
  })
}

function AppDatabaseWithConnection(conn, app) {
  var apps = conn.collection("apps")

  app.get("/apps", function(req, res) {
    sendResult(mongoFind({}, {author:true, name: true}), res)
  })
  app.get("/apps/:author", function(req, res) {
    sendResult(mongoFind({"author": req.params.author}, {name:true}), res)
  })
  app.get("/apps/:author/:name", function(req, res) {
    sendResult(mongoFind({"author": req.params.author, "name": req.params.name}, {}).map(".0"), res)
  })
  app.post("/apps", function(req, res) {
    sendResult(mongoPost(req.body), res)
  })
  function mongoPost(content) {
    var data = {
      author: content.author,
      name: content.name,
      content: JSON.stringify(content),
      date: new Date()
    }
    return Bacon.fromNodeCallback(apps, 
      "update", 
      {"author": data.author, "name": data.name}, 
      data, 
      {upsert: true})
    .map(data)
  }
  function mongoFind(query, projection) {
    return Bacon.fromNodeCallback(apps.find(query, projection).sort({date: -1}), "toArray")
  }
  function sendResult(resultE, res) {
    resultE.onError(function(err) { 
      console.log("Mongo error", err)
      res.send(err)
    })
    resultE.onValue(function(value) {
      if (value) {
        res.json(value)
      } else {
        res.status(404).send("Not found")
      }
    })
  }
}

module.exports = AppDatabase
