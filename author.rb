require 'securerandom'

class Author
  attr_reader :name, :items, :id

  def initialize(name)
    @id = SecureRandom.uuid
    @id_setter = false
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item.id
    item.author = @id
  end

  def set_id_once(newid)
    if @id_setter == false
      @id = newid
      @id_setter = true
    end
  end

  def to_json(_options = {})
  {
    id: @id,
    name: @name,
  }.to_json
  end
end
