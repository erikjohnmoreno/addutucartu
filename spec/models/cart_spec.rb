require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:cart)).to be_valid
    end
  end

  describe '#add_product' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, :green_tea) }

    it 'adds a product to the cart' do
      cart.add_product(product)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.product).to eq(product)
      expect(cart.cart_items.first.quantity).to eq(1)
    end

    it 'increments quantity when adding the same product' do
      cart.add_product(product)
      cart.add_product(product)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(2)
    end
  end

  describe '#total_price' do
    let(:cart) { create(:cart) }
    let(:green_tea) { create(:product, :green_tea) }
    let(:strawberries) { create(:product, :strawberries) }
    let(:coffee) { create(:product, :coffee) }

    context 'with no items' do
      it 'returns 0' do
        expect(cart.total_price).to eq(0)
      end
    end

    context 'with basic pricing' do
      it 'calculates total for single items' do
        cart.add_product(green_tea)
        expect(cart.total_price).to eq(3.11)
      end

      it 'calculates total for multiple different items' do
        cart.add_product(green_tea)
        cart.add_product(strawberries)
        expect(cart.total_price).to eq(8.11)
      end
    end

    context 'with Green Tea buy-one-get-one-free rule' do
      it 'applies BOGO for 2 green teas' do
        cart.add_product(green_tea)
        cart.add_product(green_tea)
        expect(cart.total_price).to eq(3.11)
      end

      it 'applies BOGO for 3 green teas' do
        cart.add_product(green_tea)
        cart.add_product(green_tea)
        cart.add_product(green_tea)
        expect(cart.total_price).to eq(6.22)
      end

      it 'applies BOGO for 4 green teas' do
        4.times { cart.add_product(green_tea) }
        expect(cart.total_price).to eq(6.22)
      end
    end

    context 'with Strawberries bulk discount rule' do
      it 'applies no discount for 2 strawberries' do
        cart.add_product(strawberries)
        cart.add_product(strawberries)
        expect(cart.total_price).to eq(10.00)
      end

      it 'applies bulk discount for 3 strawberries' do
        3.times { cart.add_product(strawberries) }
        expect(cart.total_price).to eq(13.50)
      end

      it 'applies bulk discount for 4 strawberries' do
        4.times { cart.add_product(strawberries) }
        expect(cart.total_price).to eq(18.00)
      end
    end

    context 'with Coffee bulk discount rule' do
      it 'applies no discount for 2 coffees' do
        cart.add_product(coffee)
        cart.add_product(coffee)
        expect(cart.total_price).to eq(22.46)
      end

      it 'applies bulk discount for 3 coffees' do
        3.times { cart.add_product(coffee) }
        expect(cart.total_price).to eq(22.46)
      end

      it 'applies bulk discount for 4 coffees' do
        4.times { cart.add_product(coffee) }
        expect(cart.total_price).to eq(29.95)
      end
    end

    context 'with mixed items and complex scenarios' do
      it 'handles test case: GR1,SR1,GR1,GR1,CF1' do
        cart.add_product(green_tea)   # GR1
        cart.add_product(strawberries) # SR1
        cart.add_product(green_tea)   # GR1
        cart.add_product(green_tea)   # GR1
        cart.add_product(coffee)      # CF1
        expect(cart.total_price).to eq(22.45)
      end

      it 'handles test case: GR1,GR1' do
        cart.add_product(green_tea)   # GR1
        cart.add_product(green_tea)   # GR1
        expect(cart.total_price).to eq(3.11)
      end

      it 'handles test case: SR1,SR1,GR1,SR1' do
        cart.add_product(strawberries) # SR1
        cart.add_product(strawberries) # SR1
        cart.add_product(green_tea)   # GR1
        cart.add_product(strawberries) # SR1
        expect(cart.total_price).to eq(16.61)
      end

      it 'handles test case: GR1,CF1,SR1,CF1,CF1' do
        cart.add_product(green_tea)   # GR1
        cart.add_product(coffee)      # CF1
        cart.add_product(strawberries) # SR1
        cart.add_product(coffee)      # CF1
        cart.add_product(coffee)      # CF1
        expect(cart.total_price).to eq(30.57)
      end
    end
  end
end
