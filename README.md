## write-a-game

Write games with Javascript code in the browser. Login and save your project.
Share it with others. Discover other's projects, fork them and improve.

Permanently under construction!

Currently not ready for easy game development yet. Feel free to try it anyway and
help us improve.

Try it: http://write-a-game.herokuapp.com/projects/raimohanska/example

Please find the "Project" menu in the top left corner!

My goal is to make it possible to create games like Pacman with ease.

## How-To

Upload your own image using the Upload feature on the bottom of the page.

Create a game figure and set its position

```js
// Figure with an image
var bird = new Figure("lintu1.png")

// Figure that consists of text
var text = new Figure("Hello world")

// Set position of figure
text.setPos(300, 200)
```

Rotate a figure 1 degree each 10 milliseconds

```js
interval(10, function() {
  text.rotate(1);
})
```

Make a figure move in a circle

```js
interval(10, function() {
  text.rotate(1);
  text.moveForward(1)
})
```

Control a figure based on whether SPACE and A keys are down

```js
var mila = new Figure("mila")

mila.setPos({x: 120, y: 130})

interval(100, function() {
  var spaceDown = Keyboard.isKeyDown(Keyboard.SPACE)
  var aDown = Keyboard.isKeyDown("a")
  mila.move({x: spaceDown ? -2 : 2, y: aDown ? 1 : 0})
})
```

Instead of `Keyboard.SPACE` you can use `Keyboard.UP`, `Keyboard.DOWN`, `Keyboard.LEFT`, `Keyboard.RIGHT` 
or any plain string, such as `"a"` or `"b"`, as shown in the example above.

## For developers

Instructions for the developers of the programming environment.

## Build & run

    npm install
    grunt
    ./server.coffee
    open http://localhost:3000

## What's inside

The main/editor application is in the [editor-app](editor-app) directory, from where the application is built
into the `output` directory using Grunt and [browserify](http://browserify.org/). So have a look at 
[Gruntfile](Gruntfile.coffee), [editor-app/app.coffee](editor-app/app.coffee) and
[editor-app/index.html](editor-app/index.html) for starters.

All content is served using an [Express](http://expressjs.com/) server that's bootstrapped
in [server.coffee](server.coffee) and launched on Heroku using [Procfile](Procfile). The server mainly just serves
content from the [output](output) directory but also provides a thin layer on top of a MongoDB server,
where user's applications/games are stored.

The editor application uses the excellent [CodeMirror](http://codemirror.net/) editor for manipulating
Javascript code, which it executes in an `<iframe>` that's reloaded each time the code is run.
The contents to the iframe are served from `output/game` directory and generated from files in
[game-app](game-app) directory. In addition to the static content, the user's uploaded assets (images) are encoded
as Base64 data urls into a `<script>` element and the user's Javascript code is `eval`'ed in the iframe
context.

All code is written in Coffeescript. No frontend frameworks are used. Instead, we rely on libraries 
like [JQuery](http://jquery.com/), [lodash](https://lodash.com/) and [Bacon.js](http://baconjs.github.io/).

## Backlog

Things we're going to do next.

- Make menu more inviting, prettier and easier to use
- Write first example for contributors
- Autosave to localstorage (smart)
- Write simple game
- Walls / maze for pacman type games
- Move assets to menu
- Authentication
- Automatic tests

## Contributing

Please join us! 

If you want to contribute, make a [Pull Request](https://github.com/raimohanska/write-a-game/pulls) on Github. 
If you have an idea, suggestion or a problem, make an [Issue](https://github.com/raimohanska/write-a-game/issues).
