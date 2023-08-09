require 'securerandom'

class Label
  attr_accessor :id, :title, :color, :items

  def initialize(title, color)
    @id = SecureRandom.uuid
    @id_setter = false
    @title = title
    @color = color
    @items = []
  end

  def add_item(item)
    @items << item.id
    item.label = @id
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
    title: @title,
    color: @color,
  }.to_json
  end
end

