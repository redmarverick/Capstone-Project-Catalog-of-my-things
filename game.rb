require_relative 'item.rb'
require 'date'

class Game < Item
  attr_accessor :last_played_at

  def initialize(label, genre, author, publish_date, last_played_at)
    super(label, genre, author, publish_date)
    @last_played_at = last_played_at
  end

  def can_be_archived?
    super && last_played_older_than_two_years?
  end

  def to_json(_options = {})
    {
      id: @id,
      type: 'Game',
      label: @label,
      genre: @genre,
      author: @author,
      publish_date: @publish_date,
      last_played_at: @last_played_at
    }.to_json
  end

  private

  def last_played_older_than_two_years?
    puts @last_played_at
    puts DateTime.parse(@last_played_at).to_time
    (DateTime.parse(@last_played_at).to_time <= (Time.now - 2 * 365 * 24 * 60 * 60)) # 2 years in seconds
  end
end
