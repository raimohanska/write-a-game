module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    browserify: {
      main: {
        files: { 'output/editor.js': ['editor-app/main.coffee'] },
        options: { transform: ['coffeeify'] }
      }
      game: {
        files: { 'output/game/game.js': ['game-app/game.coffee'] },
        options: { transform: ['coffeeify'] }
      }
    },
    less: {
      main: {
        files: { 'output/main.css': ['editor-app/main.less'] }
      }
      game: {
        files: { 'output/game/game.css': ['game-app/game.less'] }
      }
    }
    copy: {
      main: {
        files: [
          {expand: true, cwd: 'editor-app/', src: '**/*.html', dest: 'output/'}
        ]
      }
      game: {
        files: [
          {expand: true, cwd: 'game-app/', src: '**/*.html', dest: 'output/game/'}
        ]
      }
    }
    watch: {
      scripts: {
        files: ['game-app/**'],
        tasks: ['browserify:game', 'less:game', 'copy']
      }
    }
  }

  grunt.registerTask 'build', [ 'browserify', 'less', 'copy']
  grunt.registerTask 'default', [ 'build', 'watch' ]
