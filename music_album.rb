require_relative 'item.rb'

class MusicAlbum < Item
  def initialize(label = nil, genre = nil, author = nil, publish_date = nil, on_spotify: false)
    super(label, genre, author, publish_date)
    @on_spotify = on_spotify
  end

  def can_be_archived?()
    @on_spotify && archived
  end

  def to_json(_options = {})
    {
      type: 'MusicAlbum',
      label: @label,
      genre: @genre,
      author: @author,
      publish_date: @publish_date,
      on_spotify: @on_spotify
    }.to_json
  end
end