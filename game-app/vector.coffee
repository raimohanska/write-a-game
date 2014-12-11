class Vector2D
  constructor: (x, y) ->
    return new Vector2D(x, y)  unless this instanceof Vector2D
    if typeof x == "object"
      y = x.y
      x = x.x
    @x = x || 0
    @y = y || 0

  # Vector2D -> Vector2D
  add: (other) ->
    new Vector2D(@x + other.x, @y + other.y)

  
  # Vector2D -> Vector2D
  subtract: (other) ->
    new Vector2D(@x - other.x, @y - other.y)

  
  # Unit -> Number
  getLength: ->
    Math.sqrt @x * @x + @y * @y

  
  # Number -> Vector2D
  times: (multiplier) ->
    new Vector2D(@x * multiplier, @y * multiplier)

  
  # Unit -> Vector2D
  invert: ->
    new Vector2D(-@x, -@y)

  
  # Number -> Vector2D
  withLength: (newLength) ->
    @times newLength / @getLength()

  rotateRad: (radians) ->
    length = @getLength()
    currentRadians = @getAngle()
    resultRadians = radians + currentRadians
    rotatedUnit = new Vector2D(Math.cos(resultRadians), Math.sin(resultRadians))
    rotatedUnit.withLength length

  
  # Number -> Vector2D
  rotateDeg: (degrees) ->
    radians = degrees * 2 * Math.PI / 360
    @rotateRad radians

  
  # Unit -> Number
  getAngle: ->
    length = @getLength()
    unit = @withLength(1)
    Math.atan2 unit.y, unit.x

  getAngleDeg: ->
    @getAngle() * 360 / (2 * Math.PI)

  floor: ->
    new Vector2D(Math.floor(@x), Math.floor(@y))

  toString: ->
    "(" + x + ", " + y + ")"

Vector2D.zero = Vector2D()

module.exports = Vector2D
