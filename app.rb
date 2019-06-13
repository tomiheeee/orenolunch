require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require './src/line'
require 'json'

get '/' do
  'Ore no Lunchにようこそ'
end
