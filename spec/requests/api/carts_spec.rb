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

  describe "GET /api/carts" do
    it "returns cart with items" do
      get "/api/carts"
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      cart_data = JSON.parse(response.body)
      expect(cart_data["id"]).to be_present
      expect(cart_data["cart_items"]).to be_an(Array)
    end
  end

  describe "POST /api/carts/add_item" do
    let(:product) { create(:product, :green_tea) }

    it "adds item to cart" do
      post "/api/carts/add_item", params: { product_id: product.id }
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      result = JSON.parse(response.body)
      expect(result["success"]).to be true
      expect(result["cart_id"]).to be_present
    end
  end

  describe "DELETE /api/carts/remove_item" do
    let(:product) { create(:product, :green_tea) }

    it "returns not found when item doesn't exist in cart" do
      delete "/api/carts/remove_item", params: { product_id: product.id }
      
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to include("application/json")
      
      result = JSON.parse(response.body)
      expect(result["success"]).to be false
      expect(result["message"]).to eq("Item not found in cart")
    end
  end
end 