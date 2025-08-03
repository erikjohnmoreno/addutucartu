class PricingService
  PRICING_RULES = {
    'GR1' => {
      name: 'Buy-One-Get-One-Free',
      description: 'Every 2 items, pay for 1',
      calculate: ->(quantity, base_price) {
        paid_quantity = (quantity / 2.0).ceil
        (paid_quantity * base_price).round(2)
      }
    },
    'SR1' => {
      name: 'Bulk Discount',
      description: '4.50€ per unit when 3 or more',
      calculate: ->(quantity, base_price) {
        if quantity >= 3
          (quantity * 4.50).round(2)
        else
          (quantity * base_price).round(2)
        end
      }
    },
    'CF1' => {
      name: 'Bulk Discount',
      description: '2/3 of original price when 3 or more',
      calculate: ->(quantity, base_price) {
        if quantity >= 3
          discounted_price = base_price * (2.0 / 3.0)
          (quantity * discounted_price).round(2)
        else
          (quantity * base_price).round(2)
        end
      }
    }
  }.freeze

  def self.calculate_price(product_code, quantity, base_price)
    rule = PRICING_RULES[product_code]
    
    if rule
      rule[:calculate].call(quantity, base_price)
    else
      (quantity * base_price).round(2)
    end
  end


end 