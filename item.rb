class Item
    attr_accessor :id, :genre, :author, :source, :published_date, :archived
  
    def initialize(id, genre, author, source, published_date)
      @id = id
      @genre = genre
      @author = author
      @source = source
      @published_date = published_date
      @archived = false
    end
  
    def can_be_archived?
      (Time.now - @published_date) > 10 * 365 * 24 * 60 * 60 # 10 years in seconds
    end
  
    def move_to_archive
      @archived = can_be_archived?
    end
  end
  