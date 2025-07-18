# ACME Widgets Shopping Cart

A Rails-based shopping cart application with support for special offers, delivery charges, and flexible product management.

## 🛒 Cart Concept

This application implements a sophisticated shopping cart system with the following features:

### Core Components

- **Products**: Items with unique codes, names, and prices
- **Cart**: Shopping cart that holds multiple items
- **Cart Items**: Individual products with quantities in a cart
- **Special Offers**: Configurable discount rules (e.g., buy one get one half price)
- **Delivery Charges**: Tiered delivery pricing based on order total

### Key Features

- **Unique Product Codes**: Each product has a unique code (R01, G01, B01)
- **Flexible Pricing**: Products use Money gem for accurate currency handling
- **Special Offers**: YAML-based configuration for easy offer management
- **Delivery Charges**: Automatic calculation based on order total:
  - $0-50: $4.95 delivery
  - $50-90: $2.95 delivery
  - $90+: Free delivery
- **Cart Management**: Add, remove, update quantities, and clear cart

## 🚀 Getting Started

### Prerequisites

- Ruby 3.3+ (see `.ruby-version`)
- PostgreSQL
- Rails 8.0.1

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd acme_widgets
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Set up the database**

   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start the Rails server**
   ```bash
   bin/rails server
   ```

The application will be available at `http://localhost:3000`

## 📦 Adding Products to Cart

### Using the Rails Console

1. **Start the Rails console**

   ```bash
   bin/rails console
   ```

2. **Create a new cart**

   ```ruby
   cart = Cart.create!
   ```

3. **Add products to cart**

   ```ruby
   # Add a single Red Widget
   cart.add_item("R01")

   # Add multiple Green Widgets
   cart.add_item("G01", 3)

   # Add a Blue Widget
   cart.add_item("B01")
   ```

4. **View cart contents**

   ```ruby
   # See all items
   cart.cart_items.each do |item|
     puts "#{item.product.name} (#{item.product.code}): #{item.quantity} x #{item.product.price_formatted}"
   end

   # Get totals
   puts "Subtotal: #{Money.new(cart.subtotal, 'USD').format}"
   puts "Delivery: #{cart.delivery_charge_formatted}"
   puts "Special Offers Discount: #{cart.special_offers_discount_formatted}"
   puts "Total: #{cart.total_formatted}"
   ```

### Cart Operations

```ruby
# Update quantity
cart.update_quantity("R01", 5)

# Remove an item
cart.remove_item("G01")

# Clear entire cart
cart.clear

# Check if cart is empty
cart.empty?
```

## 🎯 Special Offers

### Current Offers

The application includes a "Buy One Get One Half Price" offer for Red Widgets (R01).

### Adding New Special Offers

1. **Edit the configuration file**

   ```bash
   # Open config/special_offers.yml
   ```

2. **Add a new offer**

   ```yaml
   special_offers:
     - product_code: 'R01'
       discount_type: 'buy_one_get_one_half_price'
     - product_code: 'G01'
       discount_type: 'buy_one_get_one_half_price'
   ```

3. **Restart the Rails server** (if running)
   ```bash
   # Stop the server (Ctrl+C) and restart
   bin/rails server
   ```

### Supported Discount Types

- `buy_one_get_one_half_price`: Every second item of the specified product is half price

### Adding New Discount Types

To add new discount types, edit `app/models/concerns/special_offers.rb`:

1. **Add the discount type to the case statement and implement the new method**

   ```ruby
   def calculate_offer_discount(offer)
     case offer[:discount_type]
     when "buy_one_get_one_half_price"
       buy_one_get_one_half_price_discount(offer)
     when "bulk_discount"
       bulk_discount(offer)  # New discount type
     else
       0
     end
   end
   ```

## 🛍️ Sample Products

The application comes with three sample products:

| Code | Name         | Price  |
| ---- | ------------ | ------ |
| R01  | Red Widget   | $32.95 |
| G01  | Green Widget | $24.95 |
| B01  | Blue Widget  | $7.95  |

### Adding New Products

1. **Via Rails console**

   ```ruby
   Product.create!(
     name: "Purple Widget",
     code: "P01",
     price_cents: 1995  # $19.95
   )
   ```

2. **Via seeds file**
   Edit `db/seeds.rb` and add new products to the `products_data` array.

## 🧪 Testing

Run the test suite:

```bash
bundle exec rspec
```

Or run specific tests:

```bash
bundle exec rspec spec/models/cart_spec.rb
```

## 📊 Example Usage

Here's a complete example of using the cart:

```ruby
# Create cart and add items
cart = Cart.create!
cart.add_item("R01", 2)  # 2 Red Widgets
cart.add_item("G01", 1)  # 1 Green Widget
cart.add_item("B01", 3)  # 3 Blue Widgets

# Calculate totals
subtotal = cart.subtotal                    # 3295 * 2 + 2495 + 795 * 3 = 10,675 cents
delivery = cart.delivery_charge             # 295 cents (order $50-90)
discount = cart.special_offers_discount     # 1647 cents (half price for 1 R01)
total = cart.total                          # 10,675 - 1,647 + 295 = 9,323 cents

puts cart.total_formatted  # "$93.23"
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file for local development:

```bash
DATABASE_URL=postgresql://localhost/acme_widgets_development
```

### Database

The application uses PostgreSQL with UUID primary keys for all models.

## 📝 License

This project is part of the ACME Widgets application suite.
