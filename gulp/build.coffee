coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
commonjs    = require 'gulp-wrap-commonjs'
uglify      = require 'gulp-uglify'
rimraf      = require 'rimraf'
runSequence = require 'run-sequence'

module.exports = (gulp) ->
  gulp.task 'build', (next) ->
    runSequence 'build:clean', 'build:src', 'build:dist', next

  gulp.task 'build:clean', (next) ->
    rimraf './build', next

  gulp.task 'build:src', ->
    gulp.src(['index.coffee', '+(src)/!(*.spec)*.coffee'])
      .pipe(coffee({bare: true}))
      .pipe(gulp.dest('build/src'))

  gulp.task 'build:dist', ->
    gulp.src('build/src/**/*.js')
      .pipe(commonjs(
        pathModifier: (path) ->
          path = path.replace "#{process.cwd()}/build/src", 'eventric-remote-socketio-client'
          path = path.replace /.js$/, ''
          return path
        ))
      .pipe(concat('eventric-remote-socketio-client.js'))
      .pipe(gulp.dest('build/dist'))
      .pipe(uglify())
      .pipe(concat('eventric-remote-socketio-client-min.js'))
      .pipe(gulp.dest('build/dist'))
