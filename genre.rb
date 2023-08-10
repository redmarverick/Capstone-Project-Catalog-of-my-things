require 'securerandom'

class Genre
  attr_reader :name, :id, :items

  def initialize(name = nil)
    @id = SecureRandom.uuid
    @id_setter = false
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item.id
    item.genre = @id
  end

  def set_id_once(newid)
    return unless @id_setter == false

    @id = newid
    @id_setter = true
  end

  def to_json(_options = {})
    {
      id: @id,
      name: @name
    }.to_json
  end
end
