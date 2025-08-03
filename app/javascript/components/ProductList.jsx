import React, { useState, useEffect } from 'react';

const ProductList = ({ onCartUpdate }) => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await fetch('/api/products');
      if (!response.ok) {
        throw new Error('Failed to fetch products');
      }
      const data = await response.json();
      setProducts(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const addToCart = async (productId) => {
    try {
      const response = await fetch('/api/carts/add_item', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ product_id: productId }),
      });

      if (response.ok) {
        const result = await response.json();
        if (onCartUpdate) {
          onCartUpdate();
        }
      } else {
        throw new Error('Failed to add item to cart');
      }
    } catch (err) {
      console.error('Error adding to cart:', err);
    }
  };

  if (loading) return <div>Loading products...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className="products-grid">
      {products.map((product) => (
        <div key={product.id} className="product-card">
          <div className="product-name">{product.name}</div>
          <div className="product-code">Code: {product.code}</div>
          <div className="product-price">€{parseFloat(product.price).toFixed(2)}</div>
          <button 
            className="add-to-cart-btn"
            onClick={() => addToCart(product.id)}
          >
            Add to Cart
          </button>
        </div>
      ))}
    </div>
  );
};

export default ProductList; 