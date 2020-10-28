require 'sinatra'

enable :sessions


get '/' do
    erb :index
end


get '/game' do
    @status_count = get_status_count()
    @word = get_word()


    erb :game
end


post '/game' do
    # update count and redirect appropriately
    @status_count = session[:status_count] + 1
    session[:status_count] = @status_count

    if @status_count == 11
        puts "game is done"
        session.clear
        redirect '/'
    else
        redirect '/game'
    end
end


def get_status_count()
    if session[:status_count]  # get status count if it already exists
        @status_count = session[:status_count]
    else  # initialize status count
        @status_count = 1
        session[:status_count] = @status_count
    end

    @status_count
end


def get_words()
    file_words = File.read("words.txt").split
    @words = file_words.sample(10)
    puts @words
    @words
end


def get_word()
    if !session[:words]
        session[:words] = get_words()
    end

    session[:words][session[:status_count].to_i - 1]
end
