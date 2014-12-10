Bacon = require("baconjs")
$ = require("jquery")

fileSelector = document.querySelector("#fileupload")
newAssetE = Bacon.fromEventTarget(fileSelector, "change")
  .map(-> fileSelector.files[0])
  .flatMap((file) -> 
    reader  = new FileReader()
    reader.readAsDataURL(file)
    Bacon.fromEventTarget(reader, "loadend")
      .map -> 
        type: file.type
        name: file.name
        data: reader.result
  )

removeAssetE = $("#assets").asEventStream("click", ".remove")
  .map(".target")
  .map((el) -> $(el).data("asset"))

assetChangeE = newAssetE.merge(removeAssetE)

module.exports = { newAssetE, removeAssetE, assetChangeE }
