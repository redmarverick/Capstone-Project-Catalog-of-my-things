require_relative '../game'
require 'rspec'
require 'date'
require 'json'

RSpec.describe Game do
  let(:label) { 'Sample Label' }
  let(:genre) { 'Sample Genre' }
  let(:author) { 'Sample Author' }
  let(:published_date) { (Date.today - 365).to_s } # One year ago
  let(:last_played_at) { (DateTime.now - 400).to_s } # 400 days ago

  subject(:game) do
    described_class.new(label, genre, author, published_date, last_played_at)
  end

  describe '#can_be_archived?' do
    it 'returns true if the parent\'s method returns true and last_played_at is more than 2 years ago' do
      allow(game).to receive(:archived).and_return(true)
      expect(game.can_be_archived?).to be_falsey

    it 'returns false if the parent\'s method returns false' do
      allow(game).to receive(:archived).and_return(false)
      expect(game.can_be_archived?).to be_falsey
    end

    it 'returns false if last_played_at is within 2 years' do
      recent_last_played_at = (DateTime.now - 300).to_s # 300 days ago
      game_recent = described_class.new(label, genre, author, published_date, recent_last_played_at)
      expect(game_recent.can_be_archived?).to be_falsey
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the game' do
      json = game.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['type']).to eq('Game')
      expect(parsed_json['last_played_at']).to eq(last_played_at)
      # Add more assertions for other attributes
    end
  end
end
