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
  app.check_data
  loop do
    display_options
    choice = get_user_choice
     case choice
    when 1 then app&.list_items("Book")
    when 2 then app&.list_items("MusicAlbum")
    when 3 then app&.list_items("Game")
    when 4 then app&.list_genres
    when 5 then app&.list_labels
    when 6 then app&.list_authors
    when 7 then app&.list_sources
    when 8 then app&.add_item("Book")
    when 9 then app&.add_item("MusicAlbum")
    when 10 then app&.add_item("Game")
    when 0 then break
    else puts "Invalid choice!"
    end
  end
  puts "Goodbye!"
  app.save_data
end

def display_options
  puts "\nOptions:"
  puts "1. List all books"
  puts "2. List all music albums"
  puts "3. List all games"
  puts "4. List all genres"
  puts "5. List all labels"
  puts "6. List all authors"
  puts "7. List all sources"
  puts "8. Add a book"
  puts "9. Add a music album"
  puts "10. Add a game"
  puts "0. Quit"
end

def get_user_choice
  print "Enter your choice: "
  gets.chomp.to_i
end

run(@app)
