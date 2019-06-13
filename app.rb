require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require './src/line'
require 'json'

get '/' do
  'Ore no Lunchにようこそ'
end

def template
  {
      "type": "template",
      "altText": "OL検索中",
      "template": {
          "type": "buttons",
          "title": "最寄りのOLを探索",
          "text": "現在の位置を送信しますか？",
          "actions": [
              {
                  "type": "uri",
                  "label": "位置を送る",
                  "uri": "line://nv/location"
              }
          ]
      }
  }
end

