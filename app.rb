require_relative 'music_album.rb'
require_relative 'genre.rb'

class App
  attr_reader :items

  def initialize
    @items = []
    @labels = []
    @genres = []
    @authors = []
    @total_data = {
      'items' => -> { @items },
      'labels' => -> { @labels },
      'genres' => -> { @genres },
      'authors' => -> { @authors }
    }
  end

  def check_data
    @total_data.each do |data_string, _|
      if File.exist?("stored_data/#{data_string}.json")
        puts 'file exists'
        json_data = File.read("stored_data/#{data_string}.json")
        data = JSON.parse(json_data)
        case data_string
        when 'items'
          check_items(data)
        when 'books'
          check_books(data)
        when 'rentals'
          check_rentals(data)
        end
        puts "Data loaded from 'stored_data/#{data_string}.json'"
      else
        puts "Data file not found: 'stored_data/#{data_string}.json'"
      end
    end
  end

  def check_items(data)
    data.each do |item_data|
      if item_data['type'] == 'MusicAlbum'
        create_student(
          person_data['name'],
          person_data['age'],
          person_data['classroom'],
          parent_permission: person_data['parent_permission']
        )
      elsif person_data['type'] == 'Teacher'
        create_teacher(
          person_data['name'],
          person_data['age'],
          person_data['specialization']
        )
      end
    end
  end

  def list_items(item_type)
    item_class = Object.const_get(item_type)
    puts "\nListing all #{item_type}:"
    @items.each do |item|
      if item.is_a?(item_class)
        puts "label: #{item.label}, genre: #{item.genre}, author: #{item.author}, ID: #{item.id}"
      end
    end
  end

  def list_genres
    puts "\nListing all genres:"
    @genres.each do |genre|
      puts "name: #{genre.name}, ID: #{genre.id}, "
    end
  end

  # def list_labels
  #   # Implement listing labels here
  # end

  # def list_authors
  #   # Implement listing authors here
  # end

  # def list_sources
  #   # Implement listing sources here
  # end

  def add_item(item_type)
    item = nil
    if item_type == 'MusicAlbum'
      item = add_music_album
    end
    @items << item
  end

  def add_music_album
    print "\nGive me the label of the Music Album please: "
    label = gets.chomp
    print "\nGive me the genre of the Music Album please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)
    print "\nGive me the author of the Music Album please: "
    author = gets.chomp
    print "\nGive me the publish date of the Music Album please (format: YYYY/MM/DD): "
    publish_date = gets.chomp
    print "\nIs this album on spotify? (y/n): "
    on_spotify_input = gets.chomp.strip.downcase
    on_spotify = (on_spotify_input == 'y')
    return MusicAlbum.new(label, genre, author, publish_date, on_spotify: on_spotify)
  end

  def genre?(genre_name)
    existing_genre = @genres.find { |genre| genre.name == genre_name }
  
    if existing_genre
      existing_genre
    else
      new_genre = Genre.new(genre_name)
      @genres << new_genre
      new_genre
    end
  end
end