require 'securerandom'

class Genre
  attr_reader :name, :id

  def initialize(name = nil)
    @id = SecureRandom.uuid
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item.id
    item.set_genre(@id)
  end

  def to_json(_options = {})
  {
    name: @name,
    items: @items
  }.to_json
end
end
