$ = require("jquery")

$menubar = $("#menubar")
$menubar.find(".menu").each ->
  $menu=$(this)
  visibleP = $menu.find(".menu-icon").asEventStream("click")
    .scan(false, (state) -> !state)
  visibleP.onValue (visible) -> $menu.find("ul").toggle(visible)

itemClickE = $menubar.find(".menu li").asEventStream("click")
  .map((e) -> $(e.target))
itemClickE.onValue (el) -> el.closest(".menu ul").hide()

module.exports =
  itemClickE: (menuId) ->
    itemClickE
      .map (el) -> el.attr("id")
      .filter((id) -> id == menuId)
