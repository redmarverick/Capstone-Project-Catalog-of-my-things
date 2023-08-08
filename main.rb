require_relative 'app'
require_relative 'item'

#require 'sqlite3'
#require 'active_record'

#ActiveRecord::Base.establish_connection(
#    adapter: 'sqlite3',
#    database: 'capstone.db'
#  )

@app = App.new

def run(app = nil)
  puts "Welcome to the Console App!"
  loop do
    display_options
    choice = get_user_choice
     case choice
    when 1 then app&.list_items("Book")
    when 2 then app&.list_items("MusicAlbum")
    when 3 then app&.list_items("Movie")
    when 4 then app&.list_items("Game")
    when 5 then app&.list_genres
    when 6 then app&.list_labels
    when 7 then app&.list_authors
    when 8 then app&.list_sources
    when 9 then app&.add_item("book")
    when 10 then app&.add_item("music album")
    when 11 then app&.add_item("movie")
    when 12 then app&.add_item("game")
    when 0 then break
    else puts "Invalid choice!"
    end
  end
  puts "Goodbye!"
end

def display_options
  puts "\nOptions:"
  puts "1. List all books"
  puts "2. List all music albums"
  puts "3. List all movies"
  puts "4. List all games"
  puts "5. List all genres"
  puts "6. List all labels"
  puts "7. List all authors"
  puts "8. List all sources"
  puts "9. Add a book"
  puts "10. Add a music album"
  puts "11. Add a movie"
  puts "12. Add a game"
  puts "0. Quit"
end

def get_user_choice
  print "Enter your choice: "
  gets.chomp.to_i
end

run(@app)
