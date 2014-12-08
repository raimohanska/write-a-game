## write-a-game

Write games with Javascript code in the browser.

Under construction!

Try it: http://write-a-game.herokuapp.com/

## Goal I

- Can write simple 2D chasing game without obstacles. Player chases prey.

Tasks

- Collision detection
- Image support (fixed set of images)
- Show score text
- Support saving to mongo
- Ability to select from a bunch of examples

## Goal II

- Can write game that has start screen, gameplay and gameover

## Goal III

- Should be able to write pacman

Task

- Uploadable images (server encodes as Base64, sends back to client)
- Walls / maze
- Save code (can rip from turtle roy)

## build & run

    npm install
    grunt
    ./server
    open http://localhost:3000
