#!./node_modules/coffee-script/bin/coffee

express = require("express")
port = process.env.PORT or 3000
app = express()
mongoUrl = process.env["MONGOHQ_URL"] or "mongodb://localhost/writegame"
require("./app-database") mongoUrl, app
app.use express.compress()
app.use express.json()
app.use "/", express.static(__dirname + "/output")
app.use "/", express.static(__dirname + "/app")
app.use "/images", express.static(__dirname + "/images")
app.use "/codemirror", express.static(__dirname + "/node_modules/codemirror")
app.listen port
console.log "Listening on port " + port
