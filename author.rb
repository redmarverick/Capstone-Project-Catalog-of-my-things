require 'securerandom'

class Author
  attr_reader :name, :items, :id

  def initialize(name)
    @id = SecureRandom.uuid
    @name = name
    @items = []
  end

  def add_item(item)
    items << item.id
    item.author = self
  end
end
