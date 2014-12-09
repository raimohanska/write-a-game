_ = require("lodash")
$ = require("jquery")

module.exports = (assetsP) ->
  assetsP.onValue (assets) ->
    elems = _.keys(assets).map (name) ->
      asset = assets[name]
      preview = $("<img>").attr("src", asset.data)
      return $("<li>")
        .append($("<a>").addClass("remove").data("asset", asset))
        .append($("<span>").addClass("name").text(asset.name))
        .append(preview)
    $("#assets ul").html(elems)
