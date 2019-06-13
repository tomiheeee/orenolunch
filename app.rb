require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require './src/line'

get '/' do
  'Ore no Lunchにようこそ'
end
