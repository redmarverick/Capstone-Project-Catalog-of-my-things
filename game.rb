require_relative 'item.rb'
require 'date'

class Game < Item
  def initialize(label, genre, author, published_date, last_played_at)
    @last_played_at = last_played_at
    super(label, genre, author, published_date)
  end

  def can_be_archived?

    super && (DateTime.parse(@last_played_at).to_time <= (Time.now - 2 * 365 * 24 * 60 * 60))
  end

  def to_json(_options = {})
    {
      id: @id,
      type: 'Game',
      label: @label,
      genre: @genre,
      author: @author,
      published_date: @published_date,
      last_played_at: @last_played_at
    }.to_json
  end
end
