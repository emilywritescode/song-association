require 'dotenv/load'
require 'sinatra'
require "uri"
require 'net/http'
require 'json'

enable :sessions


get '/newsession' do
    session.clear
    redirect '/'
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
    if params["submitted"]
        if params["title"].nil? and params["artist"].nil?
            puts "submitted empty"
            (session[:submitted] ||= []) << nil
        else
            puts "submitted: #{params["title"]} #{params["artist"]}"
            (session[:submitted] ||= []) << "#{params["title"]} #{params["artist"]}"
        end
    elsif params["skipped"]
        puts "skipped"
        (session[:submitted] ||= []) << nil
    end

    # update count
    @status_count = session[:status_count] + 1
    session[:status_count] = @status_count

    # redirect appropriately
    if @status_count == 11
        puts "game is done"
        redirect '/loading'
    else
        redirect back
    end
end


get '/loading' do
    erb :loading
end


get '/results' do
    puts '===results==='
    @words = session[:words]
    @results = []  # full title of top result on Genius
    @song_urls = []  # Genius lyrics URL
    @valids = []  # check if song has word in lyrics

    session[:submitted].each do |s|
        if s.nil?
            @results << 'No answer'
            @song_urls << nil
            @valids << nil
        else
            song_result, song_url = search(s)
            @results << song_result
            @song_urls << song_url
            @valids << true
        end
    end

    for i in 0..9
        puts "(WORD) #{@words[i]} : (RESULT) #{@results[i]} : (CORRECT) #{@valids[i]}"
    end

    @correct_submissions = @valids.count(true)

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


def search(song_query)
    uri = URI("https://api.genius.com/search")
    params = { q: "#{song_query}" }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{ENV['GENIUS_ACCESS_TOKEN']}"

    response = http.request(request)
    data = JSON.parse(response.read_body)

    song_full_title = data["response"]["hits"][0]["result"]["full_title"]
    song_url = data["response"]["hits"][0]["result"]["url"]

    [song_full_title, song_url]
end
