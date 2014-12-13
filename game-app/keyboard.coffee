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

KeyMap =
  UP: 38
  DOWN: 40
  RIGHT: 39
  LEFT: 37
  SPACE: 32

Keyboard = { keysDownP, keyDownP, isKeyDown }

_.extend(Keyboard, KeyMap)
  
module.exports = Keyboard
