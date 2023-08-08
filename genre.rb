require 'securerandom'

class Genre
  def initialize(name = nil)
    @id = SecureRandom.uuid
    @name = name
    @items = []
  end

  def add_item(itemid)
    @items << itemid
    item.set_genre(self.id)
end