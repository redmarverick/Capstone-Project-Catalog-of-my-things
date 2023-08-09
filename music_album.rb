require_relative 'item.rb'

class MusicAlbum < Item
  def initialize(label = nil, genre = nil, author = nil, published_date = nil, on_spotify: false)
    @on_spotify = on_spotify
    super(label, genre, author, published_date)
  end

  def can_be_archived?()
    super && @on_spotify
  end

  def to_json(_options = {})
    {
      id: @id,
      type: 'MusicAlbum',
      label: @label,
      genre: @genre,
      author: @author,
      published_date: @published_date,
      on_spotify: @on_spotify
    }.to_json
  end
end