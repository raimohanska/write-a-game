$ = require("jquery")

$menubar = $("#menubar")
$menubar.find(".menu").each ->
  $menu=$(this)
  visibleP = $menu.find(".title").asEventStream("click")
    .scan(false, (state) -> !state)
  visibleP.onValue (visible) -> $menu.find("ul").toggle(visible)

itemClickE = $menubar.find(".menu li").asEventStream("click")
  .map((e) -> $(e.target))
itemClickE.onValue (el) -> el.closest(".menu ul").hide()

module.exports =
  itemClickE: itemClickE.map (el) -> el.attr("id")
