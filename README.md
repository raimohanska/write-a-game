## write-a-game

Write games with Javascript code in the browser. Login and save your project.
Share it with others. Discover other's projects, fork them and improve.

Permanently under construction!

Try it: http://write-a-game.herokuapp.com/projects/raimohanska/example

My goal is to make it possible to create games like Pacman with ease.

## How-To

Upload your own image using the Upload feature on the bottom of the page.

Create a game figure and set its position

```javascript
// Figure with an image
var bird = new Figure("lintu1.png")

// Figure that consists of text
var text = new Figure("Hello world")

// Set position of figure
text.setPos(300, 200)
```

Rotate a figure 1 degree each 10 milliseconds

```
interval(10, function() {
  text.rotate(1);
})
```

Make a figure move in a circle

```
interval(10, function() {
  text.rotate(1);
  text.moveForward(1)
})
```

## For developers

Instructions for the developers of the programming environment.

## Build & run

    npm install
    grunt
    ./server.coffee
    open http://localhost:3000

## Backlog

Things we're going to do next.

- Keyboard control (isKeyDown)
- Write first example for contributors
- Autosave to localstorage (smart)
- Write simple game
- Walls / maze for pacman type games
- Move assets to menu
- Nicer menus
- Authentication
- Automatic tests

## Contributing

Please join us! 

If you want to contribute, make a [Pull Request](https://github.com/raimohanska/write-a-game/pulls) on Github. 
If you have an idea, suggestion or a problem, make an [Issue](https://github.com/raimohanska/write-a-game/issues).
