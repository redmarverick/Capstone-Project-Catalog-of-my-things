require 'date'
require 'securerandom'

class Item
  attr_accessor :label, :genre, :author
  attr_reader :id, :published_date, :archived

  def initialize(label, genre, author, published_date)
    @id = SecureRandom.uuid
    @id_setter = false
    @label = label || 'No label given'
    @genre = genre || 'No genre given'
    @author = author || 'No author given'
    @published_date = published_date
    @archived = false
    move_to_archive
  end

  def can_be_archived?
    (Time.now - DateTime.parse(@published_date).to_time) > 10 * 365 * 24 * 60 * 60 # 10 years in seconds
  end

  def move_to_archive
    @archived = can_be_archived?
  end

  def set_id_once(newid)
    return unless @id_setter == false

    @id = newid
    @id_setter = true
    @label&.add_item(self)
    @genre&.add_item(self)
    @author&.add_item(self)
  end
end
