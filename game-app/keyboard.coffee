Vector = require("./vector.coffee")

keyDownE = $("body").asEventStream("keydown").map(".keyCode")
keyUpE = $("body").asEventStream("keyup").map(".keyCode")
keysDown = {}
keysDownP = Bacon.update({},
  keyDownE, (keysDown, key) ->
    keysDown = _.clone(keysDown)
    keysDown[key] = true
    keysDown
  keyUpE, (keysDown, key) ->
    keysDown = _.clone(keysDown)
    delete keysDown[key]
    keysDown
  ).skipDuplicates(_.isEqual)

keysDownP.onValue((keys) -> keysDown = keys)

isKeyDown = (key) ->
  if typeof key == "string"
    key = key.toUpperCase().charCodeAt(0)
  keysDown[key] == true

keyDownP = (key) ->
  keysDownP.map(isKeyDown, key).skipDuplicates()

directionP = (keymap) -> keysDownP.map(directionFromKeyMap(keymap))

KeyMap =
  UP: 38
  RIGHT: 39
  DOWN: 40
  LEFT: 37
  SPACE: 32

directionVectors = [Vector(0, -1), Vector(1, 0), Vector(0, 1), Vector(-1, 0)]
arrowsKeyMap = [KeyMap.UP, KeyMap.RIGHT, KeyMap.DOWN, KeyMap.LEFT]
wdsaKeyMap = ["w", "d", "s", "a"]
directionFromKeyMap = (keymap) ->
  dir = Vector.zero
  for i in [0..3]
    if isKeyDown(keymap[i])
      dir = dir.add(directionVectors[i])
  dir

arrowsDirectionP = directionP(arrowsKeyMap)
wdsaDirectionP = directionP(wdsaKeyMap)

arrowsDirection = -> directionFromKeyMap(arrowsKeyMap)
wdsaDirection = -> directionFromKeyMap(wdsaKeyMap)

Keyboard = {
  keysDownP,
  keyDownP,
  isKeyDown,
  directionP: arrowsDirectionP,
  direction: arrowsDirection,
  direction2P: wdsaDirectionP,
  direction2: wdsaDirection
}

_.extend(Keyboard, KeyMap)
  
module.exports = Keyboard
