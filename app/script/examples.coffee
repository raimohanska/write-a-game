module.exports =
  first: """
var mila = new Figure("mila")
var ella = new Figure("ella")

mila.setPos({x: 120, y: 130})
ella.setPos({x: 200, y: 120});

interval(100, function() {
  mila.move({x: 2, y: 0})
  ella.move({x: 1, y: 0})
})
  """
