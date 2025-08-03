require 'rails_helper'

RSpec.describe PricingService, type: :service do
  describe '.calculate_price' do
    context 'with Green Tea (GR1) - Buy-One-Get-One-Free' do
      it 'calculates price for 1 item' do
        price = PricingService.calculate_price('GR1', 1, 3.11)
        expect(price).to eq(3.11)
      end

      it 'calculates price for 2 items' do
        price = PricingService.calculate_price('GR1', 2, 3.11)
        expect(price).to eq(3.11)
      end

      it 'calculates price for 3 items' do
        price = PricingService.calculate_price('GR1', 3, 3.11)
        expect(price).to eq(6.22)
      end

      it 'calculates price for 4 items' do
        price = PricingService.calculate_price('GR1', 4, 3.11)
        expect(price).to eq(6.22)
      end
    end

    context 'with Strawberries (SR1) - Bulk Discount' do
      it 'calculates price for 1 item' do
        price = PricingService.calculate_price('SR1', 1, 5.00)
        expect(price).to eq(5.00)
      end

      it 'calculates price for 2 items' do
        price = PricingService.calculate_price('SR1', 2, 5.00)
        expect(price).to eq(10.00)
      end

      it 'calculates price for 3 items' do
        price = PricingService.calculate_price('SR1', 3, 5.00)
        expect(price).to eq(13.50)
      end

      it 'calculates price for 4 items' do
        price = PricingService.calculate_price('SR1', 4, 5.00)
        expect(price).to eq(18.00)
      end
    end

    context 'with Coffee (CF1) - Bulk Discount' do
      it 'calculates price for 1 item' do
        price = PricingService.calculate_price('CF1', 1, 11.23)
        expect(price).to eq(11.23)
      end

      it 'calculates price for 2 items' do
        price = PricingService.calculate_price('CF1', 2, 11.23)
        expect(price).to eq(22.46)
      end

      it 'calculates price for 3 items' do
        price = PricingService.calculate_price('CF1', 3, 11.23)
        expect(price).to eq(22.46)
      end

      it 'calculates price for 4 items' do
        price = PricingService.calculate_price('CF1', 4, 11.23)
        expect(price).to eq(29.95)
      end
    end

    context 'with unknown product code' do
      it 'uses regular pricing' do
        price = PricingService.calculate_price('UNKNOWN', 2, 10.00)
        expect(price).to eq(20.00)
      end
    end
  end


end 