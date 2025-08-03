import React, { useState, useEffect } from 'react';
import ProductList from './ProductList';
import Cart from './Cart';

const App = () => {
  const [currentView, setCurrentView] = useState('products');
  const [cartItemCount, setCartItemCount] = useState(0);

  useEffect(() => {
    const path = window.location.pathname;
    if (path.startsWith('/carts')) {
      setCurrentView('cart');
    } else {
      setCurrentView('products');
    }
  }, []);

  const fetchCartCount = async () => {
    try {
      const response = await fetch('/api/carts');
      if (response.ok) {
        const cart = await response.json();
        const totalItems = cart.cart_items?.reduce((sum, item) => sum + item.quantity, 0) || 0;
        setCartItemCount(totalItems);
      }
    } catch (error) {
      console.error('Error fetching cart count:', error);
      setCartItemCount(0);
    }
  };

  useEffect(() => {
    fetchCartCount();
  }, []);

  const handleCartUpdate = () => {
    fetchCartCount();
  };

  const renderContent = () => {
    switch (currentView) {
      case 'cart':
        return <Cart onCartUpdate={handleCartUpdate} />;
      case 'products':
      default:
        return <ProductList onCartUpdate={handleCartUpdate} />;
    }
  };

  return (
    <div className="container">
      <header>
        <h1>Cash Register App</h1>
        <nav>
          <a 
            href="/products" 
            onClick={(e) => {
              e.preventDefault();
              setCurrentView('products');
              window.history.pushState({}, '', '/products');
            }}
            style={{ 
              color: currentView === 'products' ? '#0056b3' : '#007bff',
              fontWeight: currentView === 'products' ? 'bold' : 'normal'
            }}
          >
            Products
          </a>
          <a 
            href="/carts"
            onClick={(e) => {
              e.preventDefault();
              setCurrentView('cart');
              window.history.pushState({}, '', '/carts');
            }}
            style={{ 
              color: currentView === 'cart' ? '#0056b3' : '#007bff',
              fontWeight: currentView === 'cart' ? 'bold' : 'normal',
              position: 'relative',
              display: 'inline-block'
            }}
          >
            Cart
            {cartItemCount > 0 && (
              <span
                style={{
                  position: 'absolute',
                  top: '-8px',
                  right: '-12px',
                  backgroundColor: '#dc3545',
                  color: 'white',
                  borderRadius: '50%',
                  width: '20px',
                  height: '20px',
                  fontSize: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontWeight: 'bold'
                }}
              >
                {cartItemCount}
              </span>
            )}
          </a>
        </nav>
      </header>

      <main>
        {renderContent()}
      </main>
    </div>
  );
};

export default App; 