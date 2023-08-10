require_relative '../music_album'
require 'rspec'
require 'date'
require 'json'

RSpec.describe MusicAlbum do
  let(:label) { 'Sample Label' }
  let(:genre) { 'Sample Genre' }
  let(:author) { 'Sample Author' }
  let(:published_date) { (Date.today - 365).to_s } # One year ago

  subject(:music_album) do
    described_class.new(label, genre, author, published_date, on_spotify: true)
  end

  describe '#initialize' do
    it 'sets on_spotify to true by default' do
      expect(music_album.instance_variable_get(:@on_spotify)).to be_truthy
    end

    it 'sets on_spotify to the provided value' do
      music_album_false = described_class.new(label, genre, author, published_date, on_spotify: false)
      expect(music_album_false.instance_variable_get(:@on_spotify)).to be_falsey
    end
  end

  describe '#can_be_archived?' do
    it 'returns true if the parent\'s method returns true and on_spotify is true' do
      allow(music_album).to receive(:archived).and_return(true)
      expect(music_album.can_be_archived?).to be_truthy
    end

    it 'returns false if the parent\'s method returns false' do
      allow(music_album).to receive(:archived).and_return(false)
      expect(music_album.can_be_archived?).to be_falsey
    end

    it 'returns false if on_spotify is false' do
      music_album_false = described_class.new(label, genre, author, published_date, on_spotify: false)
      expect(music_album_false.can_be_archived?).to be_falsey
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the music album' do
      json = music_album.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['type']).to eq('MusicAlbum')
      expect(parsed_json['on_spotify']).to eq(true)
      # Add more assertions for other attributes
    end
  end
end
