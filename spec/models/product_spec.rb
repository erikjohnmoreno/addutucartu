require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:product)).to be_valid
    end

    it 'has a valid green tea factory' do
      product = build(:product, :green_tea)
      expect(product).to be_valid
      expect(product.code).to eq('GR1')
      expect(product.name).to eq('Green Tea')
      expect(product.price).to eq(3.11)
    end

    it 'has a valid strawberries factory' do
      product = build(:product, :strawberries)
      expect(product).to be_valid
      expect(product.code).to eq('SR1')
      expect(product.name).to eq('Strawberries')
      expect(product.price).to eq(5.00)
    end

    it 'has a valid coffee factory' do
      product = build(:product, :coffee)
      expect(product).to be_valid
      expect(product.code).to eq('CF1')
      expect(product.name).to eq('Coffee')
      expect(product.price).to eq(11.23)
    end
  end

  describe 'scopes' do
    let!(:green_tea) { create(:product, :green_tea) }
    let!(:strawberries) { create(:product, :strawberries) }
    let!(:coffee) { create(:product, :coffee) }

    describe '.by_code' do
      it 'finds product by code' do
        expect(Product.by_code('GR1')).to eq(green_tea)
        expect(Product.by_code('SR1')).to eq(strawberries)
        expect(Product.by_code('CF1')).to eq(coffee)
      end
    end
  end
end
