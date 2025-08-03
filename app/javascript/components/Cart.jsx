import React, { useState, useEffect } from 'react';

const Cart = ({ onCartUpdate }) => {
  const [cart, setCart] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchCart();
  }, []);

  const fetchCart = async () => {
    try {
      const response = await fetch('/api/carts');
      if (!response.ok) {
        throw new Error('Failed to fetch cart');
      }
      const data = await response.json();
      setCart(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const removeItem = async (productId) => {
    try {
      const response = await fetch('/api/carts/remove_item', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ product_id: productId }),
      });

      if (response.ok) {
        fetchCart();
        if (onCartUpdate) {
          onCartUpdate();
        }
      } else {
        throw new Error('Failed to remove item from cart');
      }
    } catch (err) {
      console.error('Error removing from cart:', err);
    }
  };

  const calculateItemPrice = (item) => {
    const { code, price } = item.product;
    const quantity = item.quantity;
    
    if (code === 'GR1') {
      const paidQuantity = Math.ceil(quantity / 2.0);
      return (paidQuantity * price).toFixed(2);
    } else if (code === 'SR1') {
      if (quantity >= 3) {
        return (quantity * 4.50).toFixed(2);
      } else {
        return (quantity * price).toFixed(2);
      }
    } else if (code === 'CF1') {
      if (quantity >= 3) {
        const discountedPrice = price * (2.0 / 3.0);
        return (quantity * discountedPrice).toFixed(2);
      } else {
        return (quantity * price).toFixed(2);
      }
    } else {
      return (quantity * price).toFixed(2);
    }
  };

  if (loading) return <div>Loading cart...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!cart) return <div>Cart not found</div>;

  return (
    <div>
      <h2>Shopping Cart</h2>
      
      {cart.cart_items && cart.cart_items.length > 0 ? (
        <>
          <div className="cart-items">
            {cart.cart_items.map((item) => (
              <div key={item.id} className="cart-item">
                <div className="item-details">
                  <div className="item-name">{item.product.name}</div>
                  <div className="item-quantity">Quantity: {item.quantity}</div>
                </div>
                <div className="item-price">
                  €{calculateItemPrice(item)}
                </div>
                <button 
                  className="remove-item-btn"
                  onClick={() => removeItem(item.product.id)}
                >
                  Remove
                </button>
              </div>
            ))}
          </div>

          <div className="cart-total">
            <span className="total-label">Total:</span>
            <span className="total-amount">€{parseFloat(cart.total_price).toFixed(2)}</span>
          </div>

          <div style={{ marginTop: '20px' }}>
            <a 
              href="/products" 
              className="add-to-cart-btn" 
              style={{ textDecoration: 'none', display: 'inline-block' }}
            >
              Continue Shopping
            </a>
          </div>
        </>
      ) : (
        <div>
          <p>Your cart is empty.</p>
          <a 
            href="/products" 
            className="add-to-cart-btn" 
            style={{ textDecoration: 'none', display: 'inline-block' }}
          >
            Browse Products
          </a>
        </div>
      )}
    </div>
  );
};

export default Cart; 