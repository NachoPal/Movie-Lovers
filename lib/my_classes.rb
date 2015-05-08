class Movies

	def initialize(key_word)
		@key_word = key_word
	end

	def get_list_of(level)
		posters = []
		years = []

		movies = Imdb::Search.new(@key_word).movies

		j=0
		i=0 
		while i < level  && j < movies.length
			if (movies[j].poster)
				unless(years.include?(movies[j].year))
					posters << movies[j].poster
					years << movies[j].year
					i+=1
				end
			end
			j+=1
		end
		[posters, years]
	end
end

class ImageResize

	def initialize(images)
		@images = images
	end

	def get_new_images(size)
		@size = size
		new_images = []

		Pathname.new("./public/img").children.each { |p| p.unlink }

		@images.each_with_index do |url, i|

			image = MiniMagick::Image.open(url)
			image.write('./public/img/poster'+i.to_s+'.jpg')
			image = MiniMagick::Image.open('./public/img/poster'+i.to_s+'.jpg')
			image_resized = image.resize size
			image_resized.write('./public/img/poster'+i.to_s+'_'+size+'.jpg')
		end
	end

	def load_new_images
		all_poster_path = []
		all_files_resize = []
		all_files = Dir["./public/img/*"]

		all_files.each do |file|
			all_files_resize << file if (file.include? @size)
		end

		(0..all_files_resize.length-1).each_with_index do |i|
			all_poster_path << "/img/"+all_files_resize[i].split('/').last 
		end
		
		all_poster_path
	end
end

class Years

	def initialize(year_list)
		@year_list = year_list
	end

	def take_random(level)
		@year_list[rand(level)]
	end
end










