# 🍽️ PopMenu - Technical Test Backend

This is a technical test developed for PopMenu company, implementing a REST API for restaurant menu management with JSON data import functionality.

## 🎯 Test Objective

Demonstrate skills in:
- REST API architecture with Ruby on Rails
- Many-to-many relationships between models
- JSON data import and processing
- Unit and integration testing

## 🚀 How to Run

```bash
# Install dependencies
bundle install

# Setup database
rails db:migrate

# Start server
rails s
```

## 📚 API Documentation

Access interactive documentation at: **http://localhost:3000/api-docs**

## 🧪 Run Tests

```bash
# Run all tests
rspec

# Run specific tests
rspec spec/models/
rspec spec/controllers/
rspec spec/services/
```

## 🔍 Code Verification

```bash
# Check code style
rubocop

# Auto-fix issues
rubocop -a
```

## 📋 Implementations Completed

### Level 1 - Basic
- ✅ `Restaurant`, `Menu` and `MenuItem` models
- ✅ Proper associations between models
- ✅ RESTful CRUD endpoints
- ✅ Comprehensive unit tests

### Level 2 - Multiple Menus
- ✅ Many-to-many relationship Menu ↔ MenuItem
- ✅ Global uniqueness of MenuItem in database
- ✅ MenuItem can be in multiple menus of the same restaurant
- ✅ Different prices per menu through `MenuAssociation`

**Note**: This level was implemented while traveling, which may have caused some comprehension issues due to limited time and infrastructure constraints. This is why there's a commit performing the refactoring of this part while developing Level 3.

### Level 3 - JSON Import
- ✅ Endpoint for JSON file upload
- ✅ JSON → application model conversion tool
- ✅ Detailed success/failure logs
- ✅ Exception handling and validations
- ✅ Support for different formats (`menu_items` and `dishes`)

## 🔗 API Endpoints

- `GET /api/v1/restaurants` - List restaurants
- `POST /api/v1/restaurants` - Create restaurant
- `GET /api/v1/restaurants/:id/menus` - List menus
- `GET /api/v1/restaurants/:id/menus/:menu_id/menu_items` - List menu items
- `POST /api/v1/menu_imports` - Import JSON data

## 🎨 Technical Decisions

- **Strategy + Factory Pattern**: For different import types (demonstrates extensibility as required - "If requirements change, your code should be adaptable")
- **Many-to-Many**: MenuAssociation for flexible relationships
- **Monetize**: Gem for price manipulation
- **Swagger**: Automatic API documentation
- **RSpec**: Tests with shoulda-matchers
