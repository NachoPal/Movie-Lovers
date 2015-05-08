require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'imdb'
require 'mini_magick'
require_relative './lib/my_classes.rb'

get '/' do
	
	erb :index
end

post '/game' do

	Pathname.new("./public/img").children.each { |p| p.unlink }
	@user_name = params[:user_name]
	erb :game
end

post '/game/show_options' do

	@key_word = "earth"
	@level = params[:level]
	redirect to(request.path+'/'+@key_word+'/'+@level+'/0')
end

get '/game/show_options/:key_word/:level/:stage' do

	@level = params[:level].to_i
	@stage = params[:stage].to_i

	@key_word = ["earth","love","alien","rose","life","man","war"]
	key_word = params[:key_word].to_s

	@film_info = Movies.new(key_word).get_list_of(@level)
	@poster_list = @film_info[0]
	@years_list = @film_info[1]
	poster = ImageResize.new(@poster_list)
	poster.get_new_images("100x200")
	@all_poster_path = poster.load_new_images

	@random_year = Years.new(@years_list).take_random(@level)

	erb :show_options
end



