Bacon = require("baconjs")
assetUploader = require("./asset-uploader.coffee")
AssetListView = require("./asset-list-view.coffee")
_ = require("lodash")

module.exports = (initialApplication) ->
  assetsP = Bacon.update initialApplication.assets,
    assetUploader.newAssetE, (assets, newFile) ->
      assets = _.clone(assets)
      assets[newFile.name] = newFile
      assets
    assetUploader.removeAssetE, (assets, asset) ->
      assets = _.clone(assets)
      delete assets[asset.name]
      assets
  AssetListView(assetsP)
  { assetsP }
