class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product)
    existing_item = cart_items.find_by(product: product)
    
    if existing_item
      existing_item.increment!(:quantity)
    else
      cart_items.create!(product: product, quantity: 1)
    end
  end

  def total_price
    return 0 if cart_items.empty?

    total = 0
    
    cart_items.includes(:product).each do |item|
      total += PricingService.calculate_price(
        item.product.code,
        item.quantity,
        item.product.price
      )
    end

    total.round(2)
  end
end
