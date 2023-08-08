require 'securerandom'

class Item
    attr_accessor :label, :genre, :author,
    attr_reader :id, :published_date, :archived
  
    def initialize(genre, author, source, published_date)
      @id = SecureRandom.uuid
      @label = 'No label given'
      @genre  = 'No genre given'
      @author = 'No author given'
      label&.add_item(@id)
      genre&.add_item(@id)
      author&.add_item(@id)
      @published_date = published_date
      @archived = false
    end
  
    def can_be_archived?
      (Time.now - @published_date) > 10 * 365 * 24 * 60 * 60 # 10 years in seconds
    end
  
    def move_to_archive
      @archived = can_be_archived?
    end

    def item.set_genre
    end

    def item.set_author
    end

    def item.set_source
    end
  end
  