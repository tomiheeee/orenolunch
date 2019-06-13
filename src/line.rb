require 'sinatra'
require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] =~ /おみくじ/
          message = {
              type: 'text',
              text:  ["大吉", "中吉", "小吉", "凶", "大凶"].shuffle.first
          }
        elsif event.message['text'] =~ /駅/
          client.reply_message(event['replyToken'], template)
        else
        message = {
            type: 'text',
            text: 'カテゴリーと位置情報からレストランを検索します。レストランを検索したい場合は、「レストラン検索」と話しかけてね！'
        }
        end
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        message = {
            type: 'text',
            text: '写真には非対応だよ！!'
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Location
           p event["message"]["latitude"]
           p event["message"]["longitude"]
# 65 APIを呼び出す関数です
           p stations(event["message"]["longitude"], event["message"]["latitude"])

      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end
