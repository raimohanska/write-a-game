$ = require("jquery")
Bacon = require("baconjs")

module.exports = (authorP, fileOpenE) ->
  $dialog = $("#file-open-dialog")
  fileLoadedE = fileOpenE.map(authorP).flatMap (author) ->
    $dialog.addClass("active")
    Bacon.fromPromise($.ajax("/apps/" + author))
      .onValue (files) ->
        $files = files.map((f) -> f.name).map (name) ->
          $("<li>").addClass("file").text(name).data("file", name)
        $dialog.find(".files").html($files)
        $dialog.addClass("loaded")

    fileSelectE = $dialog.asEventStream("click", ".file")
      .map((e)-> $(e.target).data("file"))

    fileContentE = fileSelectE.flatMap (name) ->
      Bacon.fromPromise($.ajax("/apps/" + author + "/" + name))

    fileContentE.map(".content").map(JSON.parse)

  fileLoadedE.onValue -> $dialog.removeClass("active").removeClass("loaded")

  { fileLoadedE }
  
