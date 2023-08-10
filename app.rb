require_relative 'game'
require_relative 'book'
require_relative 'music_album'

require_relative 'label'
require_relative 'genre'
require_relative 'author'

require 'json'

require 'date'

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
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

  def label?(title, color, label_id = nil)
    existing_label = @labels.find { |label| label.title == title }

    if existing_label
      existing_label
    else
      new_label = Label.new(title, color)
      if label_id.nil?
        new_label.id_changer(new_label.id)
      else
        new_label.id_changer(label_id)
      end
      @labels << new_label
      new_label
    end
  end

  def find_or_create_author(author_name, author_id = nil)
    existing_author = @authors.find { |author| author.name == author_name }

    if existing_author
      existing_author
    else
      new_author = Author.new(author_name)
      if author_id.nil?
        new_author.id_changer(new_author.id)
      else
        new_author.id_changer(author_id)
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
      if genre_id.nil?
        new_genre.id_changer(new_genre.id)
      else
        new_genre.id_changer(genre_id)
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
          check_labels(data)
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

  def check_labels(data)
    data.each do |label_data|
      label?(label_data['title'], label_data['color'], label_data['id'])
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
      case item_data['type']
      when 'MusicAlbum'
        create_music_album(
          label_by_id(item_data['label']),
          genre_by_id(item_data['genre']),
          author_by_id(item_data['author']),
          item_data['published_date'],
          on_spotify: item_data['on_spotify']
        )
        @items[-1].id_changer(item_data['id'])
      when 'Game'
        create_game(
          label_by_id(item_data['label']),
          genre_by_id(item_data['genre']),
          author_by_id(item_data['author']),
          item_data['published_date'],
          item_data['last_played_at']
        )
        @items[-1].id_changer(item_data['id'])
      when 'Book'
        create_book(
          label_by_id(item_data['label']),
          genre_by_id(item_data['genre']),
          author_by_id(item_data['author']),
          item_data['published_date'],
          item_data['publisher'],
          item_data['cover_state']
        )
        @items[-1].id_changer(item_data['id'])
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
      puts 'There are no genres yet.'
    else
      puts 'Genres:'
      @genres.each do |genre|
        puts "name: #{genre.name}, ID: #{genre.id}, items: #{genre.items}"
      end
    end
  end

  def list_labels
    if @labels.empty?
      puts 'There are no labels yet.'
    else
      puts 'Labels:'
      @labels.each do |label|
        puts "title: #{label.title}, color: #{label.color}, ID: #{label.id}, items: #{label.items}"
      end
    end
  end

  def list_authors
    if @authors.empty?
      puts 'There are no authors yet.'
    else
      puts 'Authors:'
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
        puts "label title: #{label_by_id(item.label).title}, label color: #{label_by_id(item.label).color}, genre: #{genre_by_id(item.genre).name}, author: #{author_by_id(item.author).name}, ID: #{item.id}"
      end
    end
  end

  def add_item(item_type)
    case item_type
    when 'MusicAlbum'
      add_music_album
    when 'Game'
      add_game
    when 'Book'
      add_book
    end
  end

  def add_book
    print "\nGive me the label of the Book please: "
    label_name = gets.chomp
    label_name = label_name.strip.split.map(&:capitalize).join(' ')
    label = label?(label_name, 'BlueLabel')
    print "\nGive me the genre of the Book please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)
    print "\nGive me the author of the Book please: "
    author_name = gets.chomp
    author_name = author_name.strip.split.map(&:capitalize).join(' ')
    author = find_or_create_author(author_name)
    published_date = nil
    loop do
      print "\nGive me the publish date of the Book please (format: YYYY/MM/DD): "
      published_date = gets.chomp
      begin
        DateTime.parse(published_date).to_time
        break
      rescue ArgumentError
        puts 'Invalid date format. Please use the format YYYY/MM/DD.'
        puts ''
      end
    end
    print "\nGive me the publisher: "
    publisher_name = gets.chomp
    publisher = publisher_name.strip.split.map(&:capitalize).join(' ')
    print "\nis the cover in a good or bad state? ('good'/'bad'): "
    cover_state = gets.chomp.strip.downcase
    cover_state = 'bad' unless cover_state == 'good'
    create_book(label, genre, author, published_date, publisher, cover_state)
    @items[-1].id_changer(@items[-1].id)
  end

  def create_book(label, genre, author, published_date, publisher, cover_state)
    book = Book.new(label, genre, author, published_date, publisher, cover_state)
    @items << book
  end

  def add_game
    print "\nGive me the name of the Game please: "
    label_name = gets.chomp
    label_name = label_name.strip.split.map(&:capitalize).join(' ')
    label = label?(label_name, 'BlueLabel')

    print "\nGive me the genre of the Game please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)

    print "\nGive me the author of the Game please: "
    author_name = gets.chomp
    author_name = author_name.strip.split.map(&:capitalize).join(' ')
    author = find_or_create_author(author_name)

    published_date = nil
    loop do
      print "\nGive me the publish date of the Game please (format: YYYY/MM/DD): "
      published_date = gets.chomp
      begin
        DateTime.parse(published_date).to_time
        break
      rescue ArgumentError
        puts 'Invalid date format. Please use the format YYYY/MM/DD.'
        puts ''
      end
    end

    last_played_at = nil
    loop do
      print "\nGive me the last played date of the Game please (format: YYYY/MM/DD): "
      last_played_at = gets.chomp
      begin
        DateTime.parse(last_played_at).to_time
        break
      rescue ArgumentError
        puts 'Invalid date format. Please use the format YYYY/MM/DD.'
        puts ''
      end
    end
    puts last_played_at

    create_game(label, genre, author, published_date, last_played_at)
    @items[-1].id_changer(@items[-1].id)
  end

  def create_game(label, genre, author, published_date, last_played_at)
    puts last_played_at
    game = Game.new(label, genre, author, published_date, last_played_at)
    @items << game
  end

  def add_music_album
    print "\nGive me the label of the Music Album please: "
    label_name = gets.chomp
    label_name = label_name.strip.split.map(&:capitalize).join(' ')
    label = label?(label_name, 'BlueLabel')
    print "\nGive me the genre of the Music Album please: "
    genre_name = gets.chomp
    genre_name = genre_name.strip.split.map(&:capitalize).join(' ')
    genre = genre?(genre_name)
    print "\nGive me the author of the Music Album please: "
    author_name = gets.chomp
    author = find_or_create_author(author_name)
    published_date = nil
    loop do
      print "\nGive me the publish date of the Game please (format: YYYY/MM/DD): "
      published_date = gets.chomp
      begin
        DateTime.parse(published_date).to_time
        break
      rescue ArgumentError
        puts 'Invalid date format. Please use the format YYYY/MM/DD.'
        puts ''
      end
    end
    puts published_date

    print "\nIs this album on spotify? (y/n): "
    on_spotify_input = gets.chomp.strip.downcase
    on_spotify = (on_spotify_input == 'y')
    create_music_album(label, genre, author, published_date, on_spotify)
    @items[-1].id_changer(@items[-1].id)
  end

  def create_music_album(label, genre, author, published_date, on_spotify)
    music_album = MusicAlbum.new(label, genre, author, published_date, on_spotify: on_spotify)
    @items << music_album
  end

  def label_by_id(label_id)
    @labels.find { |label| label.id == label_id }
  end

  def genre_by_id(genre_id)
    @genres.find { |genre| genre.id == genre_id }
  end

  def author_by_id(author_id)
    @authors.find { |author| author.id == author_id }
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ClassLength
