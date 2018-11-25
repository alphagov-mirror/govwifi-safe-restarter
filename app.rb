require 'sinatra/base'
require './lib/loader'

class App < Sinatra::Base
  configure :production, :staging, :development do
    enable :logging
  end

  get '/safe-restart' do
  end
end