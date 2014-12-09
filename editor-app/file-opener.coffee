$ = require("jquery")
Bacon = require("baconjs")

module.exports = (authorP, fileOpenE) ->
  fileLoadedE = fileOpenE.map(authorP).flatMap (author) ->
    $dialog = $("#file-open-dialog")
    $dialog.addClass("active")
    Bacon.fromPromise($.ajax("/apps/" + author))
      .flatMap (files) ->
        $files = files.map((f) -> f.name).map (name) ->
          $("<li>").addClass("file").text(name).data("file", name)
        $dialog.find(".files").html($files)
        $dialog.asEventStream("click", ".file")
          .map(-> $(this.target).data("file"))
      .log() 
    Bacon.once("POW")
  { fileLoadedE }
  
