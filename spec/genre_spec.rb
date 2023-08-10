require_relative '../genre'
require 'rspec'
require 'securerandom'
require 'json'

RSpec.describe Genre do
  let(:name) { 'Sample Genre' }
  let(:item_id) { SecureRandom.uuid }

  subject(:genre) { described_class.new(name) }

  describe '#initialize' do
    it 'sets the name' do
      expect(genre.name).to eq(name)
    end

    it 'generates an ID using SecureRandom' do
      expect(genre.id).to be_a(String)
      expect(genre.id).not_to be_empty
    end

    it 'sets the id_setter to false' do
      expect(genre.instance_variable_get(:@id_setter)).to be_falsey
    end

    it 'initializes the items array' do
      expect(genre.items).to be_an(Array)
      expect(genre.items).to be_empty
    end
  end

  describe '#add_item' do
    let(:item) { instance_double('Item', id: item_id, genre: nil) }

    it 'adds the item ID to the items array' do
      expect(item).to receive(:genre=).with(genre.id)
      genre.add_item(item)
      expect(genre.items).to include(item_id)
    end

    it 'sets the genre of the item' do
      expect(item).to receive(:genre=).with(genre.id)
      genre.add_item(item)
    end
  end

  describe '#set_id_once' do
    it 'sets the id if id_setter is false' do
      new_id = SecureRandom.uuid
      genre.set_id_once(new_id)
      expect(genre.id).to eq(new_id)
    end

    it 'does not set the id if id_setter is true' do
      original_id = genre.id
      new_id = SecureRandom.uuid
      genre.set_id_once(original_id)
      genre.set_id_once(new_id)
      expect(genre.id).to eq(original_id)
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the genre' do
      json = genre.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['name']).to eq(name)
      # Add more assertions for other attributes
    end
  end
end
