class MusicAlbum < Item
  def initialize(genre = nil, author = nil, source = nil, label = nil, publish_date = nil, on_spotify: false)
    super()
    @on_spotify = on_spotify
  end

  def can_be_archived?()
    on_spotify && archived
  end
end