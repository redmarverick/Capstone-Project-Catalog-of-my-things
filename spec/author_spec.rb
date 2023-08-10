require_relative '../author'
require 'rspec'
require 'securerandom'
require 'json'

RSpec.describe Author do
  let(:name) { 'Sample Author' }
  let(:item_id) { SecureRandom.uuid }

  subject(:author) { described_class.new(name) }

  describe '#initialize' do
    it 'sets the name' do
      expect(author.name).to eq(name)
    end

    it 'generates an ID using SecureRandom' do
      expect(author.id).to be_a(String)
      expect(author.id).not_to be_empty
    end

    it 'sets the id_setter to false' do
      expect(author.instance_variable_get(:@id_setter)).to be_falsey
    end

    it 'initializes the items array' do
      expect(author.items).to be_an(Array)
      expect(author.items).to be_empty
    end
  end

  describe '#add_item' do
    let(:item) { instance_double('Item', id: item_id, author: nil) }

    it 'adds the item ID to the items array' do
      expect(item).to receive(:author=).with(author.id)
      author.add_item(item)
      expect(author.items).to include(item_id)
    end

    it 'sets the author of the item' do
      expect(item).to receive(:author=).with(author.id)
      author.add_item(item)
    end
  end

  describe '#set_id_once' do
    it 'sets the id if id_setter is false' do
      new_id = SecureRandom.uuid
      author.set_id_once(new_id)
      expect(author.id).to eq(new_id)
    end

    it 'does not set the id if id_setter is true' do
      original_id = author.id
      new_id = SecureRandom.uuid
      author.set_id_once(original_id)
      author.set_id_once(new_id)
      expect(author.id).to eq(original_id)
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the author' do
      json = author.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['name']).to eq(name)
      # Add more assertions for other attributes
    end
  end
end
