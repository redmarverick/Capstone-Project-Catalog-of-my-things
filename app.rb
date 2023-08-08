require_relative 'music_album.rb'
require_relative 'genre.rb'

class App
  attr_reader :items

  def initialize
    @items = []
    @labels = []
    @genres = []
    @authors = []
  end

  def list_items(item_type)
    item_class = Object.const_get(item_type)
    puts "\nListing all #{item_type}:"
    @items.each do |item|
      if item.is_a?(item_class)
        puts "ID: #{item.id}, label: #{item.label}, genre: #{item.genre}, author: #{item.author}"
      end
    end
  end

  # def list_genres
  #   # Implement listing genres here
  # end

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