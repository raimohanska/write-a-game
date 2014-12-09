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
    sendResult(mongoFind({}), res)
  })
  app.get("/apps/:author", function(req, res) {
    sendResult(mongoFind({"content.author": req.params.author}), res)
  })
  app.get("/apps/:id", function(req, res) {
    sendResult(mongoFind({"id": req.params.id}).map(".0"), res)
  })
  app.get("/apps/:author/:name", function(req, res) {
    sendResult(mongoFind({"content.author": req.params.author, "content.description": req.params.name}).map(".0"), res)
  })
  app.post("/apps", function(req, res) {
    var data = {
      id: randomstring.generate(10),
      content: req.body,
      date: new Date()
    }
    sendResult(mongoPost(data).map(data), res)
  })
  function mongoPost(data) {
    return Bacon.fromNodeCallback(apps, "insert", [data])
  }
  function mongoFind(query) {
    return Bacon.fromNodeCallback(apps.find(query).sort({date: -1}), "toArray")
  }
  function sendResult(resultE, res) {
    resultE.onError(res, "send")
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
