require 'rails_helper'

RSpec.describe "Carts API", type: :request do
  describe "POST /api/carts" do
    it "creates a new cart" do
      expect {
        post "/api/carts"
      }.to change(Cart, :count).by(1)
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      cart = JSON.parse(response.body)
      expect(cart["id"]).to be_present
    end
  end

  describe "GET /api/carts/:id" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, :green_tea) }

    before do
      cart.add_product(product)
    end

    it "returns cart with items" do
      get "/api/carts/#{cart.id}"
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      cart_data = JSON.parse(response.body)
      expect(cart_data["id"]).to eq(cart.id)
      expect(cart_data["cart_items"]).to be_present
      expect(cart_data["cart_items"].length).to eq(1)
      expect(cart_data["cart_items"].first["product"]["name"]).to eq("Green Tea")
    end
  end

  describe "POST /api/carts/:id/add_item" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, :green_tea) }

    it "adds item to cart" do
      post "/api/carts/#{cart.id}/add_item", params: { product_id: product.id }
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      result = JSON.parse(response.body)
      expect(result["success"]).to be true
      expect(cart.reload.cart_items.count).to eq(1)
    end
  end

  describe "DELETE /api/carts/:id/remove_item" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, :green_tea) }

    before do
      cart.add_product(product)
    end

    it "removes item from cart" do
      delete "/api/carts/#{cart.id}/remove_item", params: { product_id: product.id }
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      result = JSON.parse(response.body)
      expect(result["success"]).to be true
      expect(cart.reload.cart_items.count).to eq(0)
    end
  end
end 