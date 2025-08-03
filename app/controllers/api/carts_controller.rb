class Api::CartsController < ApplicationController
  before_action :set_cart, only: [:index]

  def create
    @cart = Cart.create!
    render json: @cart
  end

  def index
    render json: @cart.as_json(
      include: { cart_items: { include: :product } },
      methods: [:total_price]
    )
  end

  def add_item
    set_cart
    product = Product.find(cart_params[:product_id])
    @cart.add_product(product)
    
    session[:cart_id] = @cart.id
    
    render json: { success: true, message: "#{product.name} added to cart", cart_id: @cart.id }
  end

  def remove_item
    set_cart
    product = Product.find(cart_params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)
    
    if cart_item
      cart_item.destroy
      render json: { success: true, message: "#{product.name} removed from cart" }
    else
      render json: { success: false, message: "Item not found in cart" }, status: :not_found
    end
  end



  private

  def cart_params
    params.permit(:product_id)
  end

  def set_cart
    @cart = Cart.find(session[:cart_id]) if session[:cart_id]
    @cart ||= Cart.create!
    session[:cart_id] = @cart.id
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create!
    session[:cart_id] = @cart.id
  end
end 