Vector = require("./vector.coffee")
counter = 1

class Figure
  constructor: (desc) ->
    if assets[desc]
      @elem = $("<img>")
        .addClass("figure")
        .attr("src", assets[desc].data)
    else
      @elem = $("<div>").addClass("figure text")
        .text(desc || ("" + (counter++)))
    $("#game").append(@elem)
    @setPos(Vector.zero)
    @setRotation(0)
  getSize: ->
    Vector(@elem.width(), @elem.height())
  setSize: ->
    size = Vector(arguments)
    @elem.css { width: size.x, height: size.y }
  setPos: ->
    @pos = Vector(arguments)
    @elem.css { left: @pos.x, top: @pos.y }
    this
  getPos: -> @pos
  setRotation: (@rotation) ->
    @elem.css { transform: "rotate("+@rotation+"deg)" }
  rotate: (degrees) ->
    @setRotation (@rotation+degrees)%360
  moveForward: (pixels) ->
    dir = Vector(1,0).rotateDeg(@rotation)
    @move(dir)
  move: ->
    diff = Vector(arguments...)
    @setPos(@pos.add(diff))

module.exports = Figure
