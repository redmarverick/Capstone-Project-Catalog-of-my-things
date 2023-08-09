require_relative 'item'

class Book < Item
  attr_accessor :publisher, :cover_state

  def initialize(label, genre, author, publisher, cover_state, published_date)
    super(label, genre, author, published_date)
    @publisher = publisher
    @cover_state = cover_state
    move_to_archive
  end

  def can_be_archived?
    archived
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