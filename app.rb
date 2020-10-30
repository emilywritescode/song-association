require 'sinatra'

enable :sessions


post '/search' do
    search = request.body.read
    puts search


end


get '/' do
    erb :index
end


get '/game' do
    @status_count = get_status_count()
    @word = get_word()
    erb :game
end


post '/game' do
    puts params
    if params["submitted"]
        puts 'submitted'
    elsif params["skipped"]
        puts 'skipped'
    end
    # update count and redirect appropriately
    @status_count = session[:status_count] + 1
    session[:status_count] = @status_count

    if @status_count == 11
        puts "game is done"
        #compute_score()
        session.clear
        redirect '/results'
    else
        redirect '/game'
    end
end


get '/results' do
    erb :results
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
    file_words.sample(10)
end


def get_word()
    if !session[:words]
        session[:words] = get_words()
    end

    session[:words][session[:status_count].to_i - 1]
end
