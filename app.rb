require 'sinatra'

get '/' do
    erb :index
end

get '/start' do
    erb :start
end
