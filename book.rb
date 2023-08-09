require_relative 'item'

class Book < Item
  attr_accessor :publisher, :cover_state

  def initialize(label, genre, author, published_date, publisher, cover_state)
    super(label, genre, author, published_date)
    @publisher = publisher
    @cover_state = cover_state
  end

  def can_be_archived?
    super || @cover_state == "bad"
  end

  def to_json(_options = {})
    {
      type: 'Book',
      label: @label,
      genre: @genre,
      author: @author,
      publisher: @publisher,
      cover_state: @cover_state,
      publish_date: @published_date
    }.to_json
  end
end
