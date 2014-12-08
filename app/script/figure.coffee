counter = 1

class Figure
  constructor: (name) ->
    @elem = $("<div>").addClass("figure")
    $("#game").append(@elem)
    text = name || ("" + (counter++))
    @elem.text(text)
    @elem.css { background: "#cccccc", "border": "1px solid black", width: "30px", height: "30px" }
  setPos: (@pos) ->
    @elem.css { left: @pos.x, top: @pos.y }
    this
  move: (@diff) ->
    newPos = { x: @pos.x + @diff.x, y: @pos.y + @diff.y }
    @setPos newPos

module.exports = Figure
