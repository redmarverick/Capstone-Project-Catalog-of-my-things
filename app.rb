def list_items(item_type)
    puts "\nListing all #{item_type}:"
    items_of_type = @items.select { |item| item.class.name.downcase == item_type.gsub(' ', '_') }
    items_of_type.each do |item|
      archived_status = item.archived ? "Archived" : "Not Archived"
      puts "#{item.title} - #{archived_status}"
    end
  end

  def list_genres
    # Implement listing genres here
  end

  def list_labels
    # Implement listing labels here
  end

  def list_authors
    # Implement listing authors here
  end

  def list_sources
    # Implement listing sources here
  end

  def add_item(item_type)
    # Implement adding items here
  end
end