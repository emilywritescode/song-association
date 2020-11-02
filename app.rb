require 'dotenv/load'
require 'sinatra'
require "uri"
require 'net/http'
require 'json'

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
    if params["submitted"]
        puts 'submitted'
        (session[:songs] ||= []) << "#{params["title"]} #{params["artist"]}"
    elsif params["skipped"]
        puts 'skipped'
        (session[:songs] ||= []) << nil
    end

    # update count and redirect appropriately
    @status_count = session[:status_count] + 1
    session[:status_count] = @status_count

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
    @songs = session[:songs]
    @songs_searched = []  # full title of top result on Genius
    @songs_valid = []  # check if song has word in lyrics

    @songs.each do |song|
        result_from_search = search(song)
        if result_from_search.nil?
            songs_searched << 'SKIPPED WORD'
            songs_valid << nil
        else
            songs_searched << result_from_search[0]
            songs_valid << true
        end
    end

    @arr = session[:words].zip(@songs_searched)
    @arr.each do |item|
        puts "(word) #{item[0]} (title) #{item[1]}"
    end

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
    if song_query.nil?
        nil
    else
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
        song_id = data["response"]["hits"][0]["result"]["id"]

        song_full_title, true
    end
end
