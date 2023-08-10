require_relative '../item'
require 'rspec'
require 'date'

RSpec.describe Item do
  let(:label) { 'Sample Label' }
  let(:genre) { 'Sample Genre' }
  let(:author) { 'Sample Author' }
  let(:published_date) { (Date.today - 365).to_s } # One year ago

  subject(:item) { Item.new(label, genre, author, published_date) }

  describe '#initialize' do
    it 'sets the published date' do
      expect(item.published_date).to eq(published_date)
    end

    it 'calls move_to_archive during initialization' do
      expect(item.archived).to eq(item.can_be_archived?)
    end
  end

  describe '#can_be_archived?' do
    it 'returns true if the published date is more than 10 years ago' do
      old_published_date = (Date.today - (11 * 365)).to_s
      old_item = Item.new(label, genre, author, old_published_date)
      expect(old_item.can_be_archived?).to be_truthy
    end

    it 'returns false if the published date is less than 10 years ago' do
      expect(item.can_be_archived?).to be_falsey
    end
  end

  describe '#move_to_archive' do
    it 'sets archived to true if the item can be archived' do
      allow(item).to receive(:can_be_archived?).and_return(true)
      item.move_to_archive
      expect(item.archived).to be_truthy
    end

    it 'sets archived to false if the item cannot be archived' do
      allow(item).to receive(:can_be_archived?).and_return(false)
      item.move_to_archive
      expect(item.archived).to be_falsey
    end
  end

  describe '#id_changer' do
    it 'sets the id if id_setter is false' do
      expect(label).to receive(:add_item)
      expect(genre).to receive(:add_item)
      expect(author).to receive(:add_item)
      new_id = SecureRandom.uuid
      item.id_changer(new_id)
      expect(item.id).to eq(new_id)
    end

    it 'does not set the id if id_setter is true' do
      expect(label).to receive(:add_item)
      expect(genre).to receive(:add_item)
      expect(author).to receive(:add_item)
      original_id = item.id
      new_id = SecureRandom.uuid
      item.id_changer(original_id)
      item.id_changer(new_id)
      expect(item.id).to eq(original_id)
    end
  end
end
