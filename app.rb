require_relative 'music_album'
require_relative 'genre'
require_relative 'game'
require_relative 'author'
require 'json'

class App
  attr_reader :items

  def initialize
    @items = []
    @labels = []
    @genres = []
    @authors = []
    @total_data = {
      'labels' => -> { @labels },
      'genres' => -> { @genres },
      'authors' => -> { @authors },
      'items' => -> { @items }
    }
  end

#Original function

# def create_music_album(label, genre_name, author, publish_date, on_spotify)
#    genre = find_or_create_genre(genre_name)
#    music_album = MusicAlbum.new(label, genre, author, publish_date, on_spotify: on_spotify)
#   @items << music_album
# end

  def find_or_create_author(author_name, author_id = nil)
    existing_author = @authors.find { |author| author.name == author_name }
  
    if existing_author
      existing_author
    else
      new_author = Author.new(author_name)
      if author_id != nil
        new_author.set_id_once(author_id)
      else
        new_author.set_id_once(new_author.id)
      end
      @authors << new_author
      new_author
    end
  end

  def genre?(genre_name, genre_id = nil)
    existing_genre = @genres.find { |genre| genre.name == genre_name }
  
    if existing_genre
      existing_genre
    else
      new_genre = Genre.new(genre_name)
      if genre_id == nil
        new_genre.set_id_once(new_genre.id)
      else
        new_genre.set_id_once(genre_id)
      end
      @genres << new_genre
      new_genre
    end
  end

  def check_data
    @total_data.each do |data_string, _|
      if File.exist?("stored_data/#{data_string}.json")
        puts 'file exists'
        json_data = File.read("stored_data/#{data_string}.json")
        data = JSON.parse(json_data)
        case data_string
        when 'labels'
          # check_labels(data)
        when 'genres'
          check_genres(data)
        when 'authors'
          check_authors(data)
        when 'items'
          check_items(data)
        end
        puts "Data loaded from 'stored_data/#{data_string}.json'"
      else
        puts "Data file not found: 'stored_data/#{data_string}.json'"
      end
    end
  end

  def check_genres(data)
    data.each do |genre_data|
      genre?(genre_data['name'], genre_data['id'])
    end
  end

  def check_authors(data)
    data.each do |author_data|
      find_or_create_author(author_data['name'], author_data['id'])
    end
  end

  def check_items(data)
    data.each do |item_data|
      if item_data['type'] == 'MusicAlbum'
        create_music_album(
          item_data['label'],
          genre_by_id(item_data['genre']),
          author_by_id(item_data['author']),
          item_data['publish_date'],
          on_spotify: item_data['on_spotify']
        )
        @items[-1].set_id_once(item_data['id'])
      elsif item_data['type'] == 'Game'
        create_game(
          item_data['label'],
          genre_by_id(item_data['genre']),
          author_by_id(item_data['author']),
          item_data['publish_date'],
          on_spotify: item_data['on_spotify']
        )
        @items[-1].set_id_once(item_data['id'])
      end
    end
  end

  def save_data
    @total_data.each do |data_string, data_adress|
      datajson = JSON.generate(data_adress.call)
      File.open("stored_data/#{data_string}.json", 'w') do |file|
        file.write(datajson)
        puts "write to stored_data/#{data_string}.json the data = #{data_adress.call}"
      end
    end
  end

  def list_genres
    if @genres.empty?
      puts "There are no genres yet."
    else
      puts "Genres:"
      @genres.each do |genre|
        puts "name: #{genre.name}, ID: #{genre.id}, items: #{genre.items}"
      end
    end
  end

  # def list_labels
  #   # Implement listing labels here
  # end

  def list_authors
    if @authors.empty?
      puts "There are no authors yet."
    else
      puts "Authors:"
      @authors.each do |author|
        puts "name: #{author.name}, ID: #{author.id}, items: #{author.items}"
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

  def add_item(item_type)
    item = nil
    if item_type == 'MusicAlbum'
      add_music_album
    elsif item_type == 'Game'
      item = add_game
    end
  end

  def add_game
    print "\nGive me the name of the Game please: "
    label = gets.chomp
  
    print "\nGive me the genre of the Game please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)
  
    print "\nGive me the author of the Game please: "
    author_name = gets.chomp
    author_name = author_name.strip.split.map(&:capitalize).join(' ')
    author = find_or_create_author(author_name)
  
    print "\nGive me the publish date of the Game please (format: YYYY/MM/DD): "
    publish_date = Date.parse(gets.chomp)
  
    print "\nGive me the last played date of the Game please (format: YYYY/MM/DD): "
    last_played_at = Date.parse(gets.chomp)
  
    create_game(label, genre, author, publish_date, last_played_at)
    @items[-1].set_id_once(@items[-1].id)
  end  

  def create_game(label, genre, author, publish_date, last_played_at)
    game = Game.new(label, genre, author, publish_date, last_played_at)
    @items << game
  end

  def add_music_album
    print "\nGive me the label of the Music Album please: "
    label = gets.chomp
    print "\nGive me the genre of the Music Album please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)
    print "\nGive me the author of the Music Album please: "
    author_name = gets.chomp
    author = find_or_create_author(author_name)
    print "\nGive me the publish date of the Music Album please (format: YYYY/MM/DD): "
    publish_date = gets.chomp
    print "\nIs this album on spotify? (y/n): "
    on_spotify_input = gets.chomp.strip.downcase
    on_spotify = (on_spotify_input == 'y')
    create_music_album(label, genre, author, publish_date, on_spotify)
    @items[-1].set_id_once(@items[-1].id)
  end

  def create_music_album(label, genre, author, publish_date, on_spotify)
    music_album = MusicAlbum.new(label, genre, author, publish_date, on_spotify: on_spotify)
    @items << music_album
  end

  def genre_by_id(genre_id)
    existing_genre = @genres.find { |genre| genre.id == genre_id }
    existing_genre
  end

  def author_by_id(author_id)
    existing_author = @authors.find { |author| author.id == author_id }
    existing_author
  end
end