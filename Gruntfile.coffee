module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    browserify: {
      main: {
        files: { 'output/bundle.js': ['app/script/main.coffee'] },
        options: { transform: ['coffeeify'] }
      }
      game: {
        files: { 'output/game.js': ['app/script/game.coffee'] },
        options: { transform: ['coffeeify'] }
      }
    },
    less: {
      main: {
        files: { 'output/main.css': ['app/less/main.less'] }
      }
      game: {
        files: { 'output/game.css': ['app/less/game.less'] }
      }
    }
    copy: {
      html: {
        files: [
          {expand: true, cwd: 'app/', src: '**/*.html', dest: 'output/'}
        ]
      }
    }
    watch: {
      scripts: {
        files: ['app/script/**'],
        tasks: 'browserify'
      },
      less: {
        files: ['app/less/**'],
        tasks: 'less'
      },
      html: {
        files: ['app/**/*.html'],
        tasks: 'copy'
      }
    }
  }

  grunt.registerTask 'build', [ 'browserify', 'less', 'copy']
  grunt.registerTask 'default', [ 'build', 'watch' ]
