require_relative '../label'
require 'rspec'
require 'securerandom'
require 'json'

RSpec.describe Label do
  let(:title) { 'Sample Label' }
  let(:color) { 'Sample Color' }
  let(:item_id) { SecureRandom.uuid }

  subject(:label) { described_class.new(title, color) }

  describe '#initialize' do
    it 'sets the title' do
      expect(label.title).to eq(title)
    end

    it 'sets the color' do
      expect(label.color).to eq(color)
    end

    it 'generates an ID using SecureRandom' do
      expect(label.id).to be_a(String)
      expect(label.id).not_to be_empty
    end

    it 'sets the id_setter to false' do
      expect(label.instance_variable_get(:@id_setter)).to be_falsey
    end

    it 'initializes the items array' do
      expect(label.items).to be_an(Array)
      expect(label.items).to be_empty
    end
  end

  describe '#add_item' do
    let(:item) { instance_double('Item', id: item_id, label: nil) }

    it 'adds the item ID to the items array' do
      expect(item).to receive(:label=).with(label.id)
      label.add_item(item)
      expect(label.items).to include(item_id)
    end

    it 'sets the label of the item' do
      expect(item).to receive(:label=).with(label.id)
      label.add_item(item)
    end
  end

  describe '#id_changer' do
    it 'sets the id if id_setter is false' do
      new_id = SecureRandom.uuid
      label.id_changer(new_id)
      expect(label.id).to eq(new_id)
    end

    it 'does not set the id if id_setter is true' do
      original_id = label.id
      new_id = SecureRandom.uuid
      label.id_changer(original_id)
      label.id_changer(new_id)
      expect(label.id).to eq(original_id)
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the label' do
      json = label.to_json
      expect(json).to be_a(String)
      parsed_json = JSON.parse(json)
      expect(parsed_json['title']).to eq(title)
      expect(parsed_json['color']).to eq(color)
      # Add more assertions for other attributes
    end
  end
end
