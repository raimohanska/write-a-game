## write-a-game

Write games with Javascript code in the browser.

Under construction!

Try it: http://write-a-game.herokuapp.com/

## Next up

- Keyboard control (isKeyDown)
- Write first example for contributors
- Autosave to localstorage (smart)
- Write simple game
- Walls / maze for pacman type games
- Move assets to menu
- Nicer menus
- Authentication

## Goal

Should be able to write pacman!

## Game API

### Figure

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

## build & run

    npm install
    grunt
    ./server.coffee
    open http://localhost:3000
