require_relative 'item'

class Book < Item
  attr_accessor :publisher, :cover_state

  # rubocop:disable Metrics/ParameterLists
  def initialize(label, genre, author, published_date, publisher, cover_state)
    @publisher = publisher
    @cover_state = cover_state
    super(label, genre, author, published_date)
  end
  # rubocop:enable Metrics/ParameterLists

  def can_be_archived?
    super || @cover_state == 'bad'
  end

  def to_json(_options = {})
    {
      id: @id,
      type: 'Book',
      label: @label,
      genre: @genre,
      author: @author,
      published_date: @published_date,
      publisher: @publisher,
      cover_state: @cover_state
    }.to_json
  end
end
