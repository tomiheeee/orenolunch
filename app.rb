require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require './src/line'
require 'net/http'
require 'json'

GNAVI_KEYID = "cdb4d51db76b36b23c2740c4ceb9f933"
GNAVI_SEARCHAPI = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
GNAVI_CATEGORY_LARGE_SEARCH_API = "https://api.gnavi.co.jp/master/CategoryLargeSearchAPI/v3/"


get '/' do
  'Ore no Lunchにようこそ'
end

helpers do
  def template
    {
        "type": "template",
        "altText": "OL検索中",
        "template": {
            "type": "buttons",
            "title": "最寄りのOLを検索",
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


  # 送られた位置情報から緯度,経度を取得
  def get_location(longitude, latitude)
    uri = URI(GNAVI_SEARCHAPI)
    uri.query = URI.encode_www_form({
    method: "getRestaurants",
        x: longitude,
        y: latitude
    })
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)["name"]
  end

  # ぐるなびAPIでレストランを検索
  def get_restaurants latitude, longitude
    # 緯度,経度,範囲を指定
    params = "?keyid=#{GNAVI_KEYID}&latitude=#{latitude}&longitude=#{longitude}"
    restaurants = JSON.parse(RestClient.get GNAVI_SEARCHAPI + params)
    restaurants
  end

  def gnavi_api(latitude, longitude):
      key = GNAVI_KEYID
      url = GNAVI_SEARCHAPI
      search_range = '1' # 半径300mを検索
  params = urllib.parse.urlencode({
                                      'keyid': key,
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'range': search_range,
                                      'freeword': freeword
                                      # 最大10件

  })
  try:
      response = urllib.request.urlopen(url + '?' + params)
  return response.read()
  except:
      raise Exception('ぐるなびAPIへのアクセスに失敗しました')
  end

  # APIで取得したレストラン情報をLINEで送信できる構文に整形
  def set_restaurants_info restaurants
    elements = []
    restaurants["rest"].each do |rest|
      image = rest["image_url"]["shop_image1"].empty? ? "http://techpit-bot.herokuapp.com/images/no-image.png" : rest["image_url"]["shop_image1"]
      elements.push(
          {
              "type": "set_restarunts_info",
              "altText": "This is a buttons template",
              "set_restarunts_info": {
                  "type": "buttons",
                  "thumbnailImageUrl": image,
                  "imageAspectRatio": "rectangle",
                  "imageSize": "cover",
                  "imageBackgroundColor": "#FFFFFF",
                  "title": rest["name"],
                  "text": "ここ何書こう",
                  "defaultAction": {
                      "type": "uri",
                      "label": "View detail",
                      "uri": rest["url_mobile"]
                  },
                  "actions": [
                      {
                          "type": "uri",
                          "label": "View detail",
                          "uri": rest["url_mobile"]
                      },

                  ]
              }
          }
      )
    end
  end




end
