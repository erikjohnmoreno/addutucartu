# Cash Register App

A simple cash register application built with Ruby on Rails and React.

## Setup

### Prerequisites
- Ruby 3.3.0
- PostgreSQL
- Node.js
- Yarn

### Installation

1. Clone and install dependencies:
```bash
git clone <repository-url>
cd amenitiz
bundle install
yarn install
```

2. Setup database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

3. Start the application:
```bash
bin/dev
```

4. Open http://localhost:3000 in your browser

## How It Works

### Products Available
- **Green Tea (GR1)**: €3.11
- **Strawberries (SR1)**: €5.00  
- **Coffee (CF1)**: €11.23

### Special Pricing Rules

**Green Tea (GR1)**: Buy-One-Get-One-Free
- Buy 2, pay for 1
- Buy 4, pay for 2

**Strawberries (SR1)**: Bulk Discount
- Buy 3 or more: €4.50 each
- Buy less than 3: €5.00 each

**Coffee (CF1)**: Bulk Discount
- Buy 3 or more: 2/3 of original price
- Buy less than 3: full price

### Using the App

1. **View Products**: See all available products on the main page
2. **Add to Cart**: Click "Add to Cart" on any product
3. **View Cart**: Click "Cart" in the navigation to see your items
4. **Remove Items**: Click "Remove" next to any item in the cart
5. **See Total**: The total price with discounts is shown at the bottom

### Example Calculations

| Items in Cart | Total Price |
|---------------|-------------|
| 2 Green Tea | €3.11 (BOGO) |
| 3 Strawberries | €13.50 (bulk discount) |
| 2 Coffee | €22.46 (regular price) |

## Testing

Run the test suite:
```bash
bundle exec rspec
```
