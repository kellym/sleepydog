# Description
#   Sleepy Dog
#
# Commands:
#   so tired/pooped - show a random dog

class SleepyDog

  constructor: (@robot) ->
    @dog_host = 'api.github.com'
    @dog_path = '/repositories/17177621/contents/images'
    @image_path = 'https://raw.github.com/kellym/sleepydog/master/'
    @https = require 'https'
    @http = require 'http'
    @images = []

    @robot.brain.on 'loaded', =>
      @robot.brain.data.sleepydog = []
      @loadSleepyDog()

  loadSleepyDog: ->
    data = ''
    @https.get { host: @dog_host, path: @dog_path, headers: { 'User-Agent': 'Hubot'  } }, (res) =>
      res.on 'data', (chunk) =>
        data += chunk.toString()
      res.on 'end', () =>
        json = JSON.parse(data)
        for image in json
          @robot.brain.data.sleepydog.push "#{@image_path}#{image['path']}"

  show: (msg) ->
    @images = @robot.brain.data.sleepydog
    msg.send(@images[Math.floor(Math.random()*@images.length)])

module.exports = (robot) ->
  sleepydog = new SleepyDog robot
  robot.hear /(^|\W)so tired\!?($|\W)/i, (msg) ->
    sleepydog.show msg
  robot.hear /(^|\W)pooped\!?($|\W)/i, (msg) ->
    sleepydog.show msg
