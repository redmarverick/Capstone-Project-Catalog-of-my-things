class Game < Item
  attr_accessor :last_played_at

  def initialize(label, genre, author, publish_date, last_played_at)
    super(label, genre, author, publish_date)
    @last_played_at = last_played_at
  end

  def can_be_archived?
    super && last_played_older_than_two_years?
  end

  private

  def last_played_older_than_two_years?
    last_played_at <= (Time.now - 2 * 365 * 24 * 60 * 60) # 2 years in seconds
  end
end
