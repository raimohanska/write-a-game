counter = 1

class Figure
  constructor: (desc) ->
    if assets[desc]
      @elem = $("<img>")
        .addClass("figure")
        .attr("src", assets[desc].data)
    else
      @elem = $("<div>").addClass("figure")
        .text(desc || ("" + (counter++)))
        .css { background: "#cccccc", "border": "1px solid black", width: "30px", height: "30px" }
    $("#game").append(@elem)
  setPos: (pos) ->
    @pos = _.clone(pos)
    @elem.css { left: @pos.x, top: @pos.y }
    this
  getPos: -> @pos
  move: (@diff) ->
    newPos = { x: @pos.x + @diff.x, y: @pos.y + @diff.y }
    @setPos newPos

module.exports = Figure
