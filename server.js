var express = require('express');
var port = process.env.PORT || 3000;
var app = express();
var mongoUrl = process.env["MONGOHQ_URL"] || "mongodb://localhost/writegame"

require("./app-database")(mongoUrl, app)

app.use('/', express.static(__dirname + '/output'))
app.use('/', express.static(__dirname + '/app'))
app.use('/images', express.static(__dirname + '/images'))
app.use('/codemirror', express.static(__dirname + '/node_modules/codemirror'))
app.listen(port)

console.log("Listening on port " + port)
