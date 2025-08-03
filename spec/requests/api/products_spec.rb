require 'rails_helper'

RSpec.describe "Products API", type: :request do
  describe "GET /api/products" do
    let!(:green_tea) { create(:product, :green_tea) }
    let!(:strawberries) { create(:product, :strawberries) }
    let!(:coffee) { create(:product, :coffee) }

    it "returns all products as JSON" do
      get "/api/products"
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      
      products = JSON.parse(response.body)
      expect(products.length).to eq(3)
      
      expect(products.map { |p| p["code"] }).to contain_exactly("GR1", "SR1", "CF1")
      expect(products.map { |p| p["name"] }).to contain_exactly("Green Tea", "Strawberries", "Coffee")
    end

    it "verifies database isolation between tests" do
      # This test should only see the 3 products created in the let! blocks
      expect(Product.count).to eq(3)
      expect(Product.pluck(:code)).to contain_exactly("GR1", "SR1", "CF1")
    end
  end
end 