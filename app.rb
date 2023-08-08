class App
  attr_reader :items

  def initialize
    @items = []
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
    item_class = Object.const_get(item_type)
    item = item_class.new
    @items << item
  end
end