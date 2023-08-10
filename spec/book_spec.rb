require_relative '../book'
require 'rspec'
require 'date'
require 'json'

RSpec.describe Book do
  let(:label) { 'Sample Label' }
  let(:genre) { 'Sample Genre' }
  let(:author) { 'Sample Author' }
  let(:published_date) { (Date.today - 365).to_s } # One year ago
  let(:publisher) { 'Sample Publisher' }
  let(:cover_state) { 'bad' }

  subject(:book) do
    described_class.new(label, genre, author, published_date, publisher, cover_state)
  end

  describe '#initialize' do
    it 'sets the publisher and cover_state' do
      expect(book.publisher).to eq(publisher)
      expect(book.cover_state).to eq(cover_state)
    end
  end

  describe '#can_be_archived?' do
    it 'returns true if the parent\'s method returns true' do
      allow(book).to receive(:archived).and_return(true)
      expect(book.can_be_archived?).to be_truthy
    end

    it 'returns false if the parent\'s method returns false and cover state is not bad' do
      allow(book).to receive(:archived).and_return(false)
      expect(book.can_be_archived?).to be_truthy
    end

    it 'returns true if the cover state is bad' do
      allow(book).to receive(:cover_state).and_return('bad')
      expect(book.can_be_archived?).to be_truthy
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the book' do
      json = book.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['type']).to eq('Book')
      expect(parsed_json['publisher']).to eq(publisher)
      expect(parsed_json['cover_state']).to eq(cover_state)
      # Add more assertions for other attributes
    end
  end
end
