import 'package:flutter_notes/model/food_item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_items.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE FoodItems(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, category TEXT NOT NULL, description TEXT NOT NULL, price REAL NOT NULL, image TEXT NOT NULL, quantity INTEGER DEFAULT 0)');

    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final List<Map<String, dynamic>> dummyItems = [
      {
        'name': 'Classic Burger',
        'category': 'Recommended',
        'description':
            'Juicy beef patty with fresh lettuce, tomato, onions, and our special sauce on a toasted sesame bun.',
        'price': 199.0,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Chicken Burger',
        'category': 'Recommended',
        'description':
            'Tender grilled chicken breast with crisp lettuce, mayo, and pickles on a freshly baked bun.',
        'price': 179.0,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Double Cheese Burger',
        'category': 'Recommended',
        'description':
            'Two juicy beef patties with double cheese, lettuce, onions, and our signature sauce.',
        'price': 249.0,
        'image':
            'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Veggie Delight Burger',
        'category': 'Recommended',
        'description':
            'House-made vegetable patty with fresh greens, tomato, cucumber, and vegan mayo.',
        'price': 169.0,
        'image':
            'https://images.unsplash.com/photo-1550950158-d0d960dff51b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'BBQ Beef Burger',
        'category': 'Recommended',
        'description':
            'Smoked beef patty with tangy BBQ sauce, crispy bacon, and cheddar cheese.',
        'price': 229.0,
        'image':
            'https://images.unsplash.com/photo-1551782450-17144efb9c50?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Spicy Mexican Burger',
        'category': 'Recommended',
        'description':
            'Jalapeno-infused beef patty with pepper jack cheese, guacamole, and spicy salsa.',
        'price': 219.0,
        'image':
            'https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Mushroom Swiss Burger',
        'category': 'Recommended',
        'description':
            'Beef patty topped with sautéed mushrooms and melted Swiss cheese on a brioche bun.',
        'price': 209.0,
        'image':
            'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Breakfast Burger',
        'category': 'Recommended',
        'description':
            'Beef patty with fried egg, bacon, hash brown, and cheese—the perfect morning starter.',
        'price': 189.0,
        'image':
            'https://images.unsplash.com/photo-1484344597163-9347ad5cb26d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Hawaiian Burger',
        'category': 'Recommended',
        'description':
            'Beef patty with grilled pineapple, teriyaki sauce, bacon, and provolone cheese.',
        'price': 199.0,
        'image':
            'https://images.unsplash.com/photo-1550317138-10000687a72b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Black Bean Burger',
        'category': 'Recommended',
        'description':
            'House-made black bean patty with avocado, corn salsa, and chipotle aioli.',
        'price': 189.0,
        'image':
            'https://images.unsplash.com/photo-1520072959219-c595dc870360?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Family Combo',
        'category': 'Combos',
        'description':
            'Four burgers, four fries, and four drinks—perfect for family gatherings.',
        'price': 799.0,
        'image':
            'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Duo Burger Combo',
        'category': 'Combos',
        'description':
            'Two classic burgers, two regular fries, and two medium drinks at a special price.',
        'price': 399.0,
        'image':
            'https://images.unsplash.com/photo-1606755962773-d324e0a13086?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Chicken Lovers Combo',
        'category': 'Combos',
        'description':
            'Two chicken burgers, chicken wings, fries, and two drinks for chicken enthusiasts.',
        'price': 449.0,
        'image':
            'https://images.unsplash.com/photo-1562967914-608f82629710?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Veggie Party Combo',
        'category': 'Combos',
        'description':
            'Three veggie burgers, sweet potato fries, onion rings, and three drinks.',
        'price': 499.0,
        'image':
            'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Double Date Combo',
        'category': 'Combos',
        'description':
            'Two premium burgers, two regular burgers, shared fries platter, and four drinks.',
        'price': 599.0,
        'image':
            'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Game Night Combo',
        'category': 'Combos',
        'description':
            'Six sliders, chicken wings, loaded nachos, mozzarella sticks, and four drinks.',
        'price': 699.0,
        'image':
            'https://images.unsplash.com/photo-1561758033-d89a9ad46330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Kids Special Combo',
        'category': 'Combos',
        'description':
            'Two junior burgers, two small fries, two juice boxes, and two ice creams.',
        'price': 349.0,
        'image':
            'https://images.unsplash.com/photo-1561758033-d89a9ad46330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Office Lunch Combo',
        'category': 'Combos',
        'description':
            'Ten assorted burgers, large fries platter, and ten drinks for your team.',
        'price': 1299.0,
        'image':
            'https://images.unsplash.com/photo-1554433607-66b5efe9d304?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Breakfast Combo',
        'category': 'Combos',
        'description':
            'Breakfast burger, hash browns, and coffee or orange juice to start your day.',
        'price': 249.0,
        'image':
            'https://images.unsplash.com/photo-1554433607-66b5efe9d304?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Premium Combo',
        'category': 'Combos',
        'description':
            'Special burger, truffle fries, onion rings, and a craft soda or milkshake.',
        'price': 349.0,
        'image':
            'https://images.unsplash.com/photo-1525268771113-32d9e9021a97?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Regular Burger',
        'category': 'Regular Burgers',
        'description':
            'Standard beef patty with lettuce, tomato, onions, and ketchup on a plain bun.',
        'price': 149.0,
        'image':
            'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Cheeseburger',
        'category': 'Regular Burgers',
        'description':
            'Regular beef patty with American cheese, lettuce, tomato, and mayo.',
        'price': 159.0,
        'image':
            'https://images.unsplash.com/photo-1551615593-ef5fe247e8f7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Bacon Burger',
        'category': 'Regular Burgers',
        'description':
            'Regular patty topped with crispy bacon, lettuce, and mayo.',
        'price': 169.0,
        'image':
            'https://images.unsplash.com/photo-1553979459-d2229ba7433b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Junior Burger',
        'category': 'Regular Burgers',
        'description':
            'Smaller portion beef patty with simple toppings—perfect for light eaters.',
        'price': 129.0,
        'image':
            'https://images.unsplash.com/photo-1596956470007-2bf6095e7e16?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Plain Chicken Burger',
        'category': 'Regular Burgers',
        'description':
            'Simple grilled chicken patty with lettuce and mayo on a regular bun.',
        'price': 159.0,
        'image':
            'https://images.unsplash.com/photo-1596956470007-2bf6095e7e16?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Veggie Burger',
        'category': 'Regular Burgers',
        'description':
            'Basic vegetable patty with lettuce, tomato, and cucumber.',
        'price': 139.0,
        'image':
            'https://images.unsplash.com/photo-1585238342024-78d387f4a707?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Fish Burger',
        'category': 'Regular Burgers',
        'description':
            'Crispy fish fillet with tartar sauce and lettuce on a regular bun.',
        'price': 159.0,
        'image':
            'https://images.unsplash.com/photo-1581873372796-635b67ca2008?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Egg Burger',
        'category': 'Regular Burgers',
        'description':
            'Beef patty with a fried egg on top, with simple lettuce and mayo.',
        'price': 149.0,
        'image':
            'https://images.unsplash.com/photo-1525164286253-04e68b9d94c6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Garden Burger',
        'category': 'Regular Burgers',
        'description':
            'Regular beef patty with extra fresh vegetables and light dressing.',
        'price': 149.0,
        'image':
            'https://images.unsplash.com/photo-1547584370-2cc98b8b8dc8?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Slider Burger',
        'category': 'Regular Burgers',
        'description':
            'Three mini burgers with different toppings on soft mini buns.',
        'price': 169.0,
        'image':
            'https://images.unsplash.com/photo-1550317138-10000687a72b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Special Burger',
        'category': 'Specials',
        'description':
            'Our signature special burger with premium beef, artisanal cheese, and secret sauce.',
        'price': 249.0,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Gourmet Truffle Burger',
        'category': 'Specials',
        'description':
            'Wagyu beef patty with truffle aioli, caramelized onions, and aged cheddar.',
        'price': 299.0,
        'image':
            'https://images.unsplash.com/photo-1542574271-7f3b92e6c821?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Monster Tower Burger',
        'category': 'Specials',
        'description':
            'Triple beef patties with bacon, three types of cheese, and all the fixings.',
        'price': 349.0,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Surf & Turf Burger',
        'category': 'Specials',
        'description':
            'Beef patty topped with garlic butter shrimp, arugula, and special seafood sauce.',
        'price': 329.0,
        'image':
            'https://images.unsplash.com/photo-1551782450-17144efb9c50?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Seasonal Burger',
        'category': 'Specials',
        'description':
            "Chef's special made with seasonal ingredients and limited-time flavors.",
        'price': 269.0,
        'image':
            'https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Ultimate Cheese Lover Burger',
        'category': 'Specials',
        'description':
            'Beef patty smothered with five premium cheeses and cheese sauce.',
        'price': 279.0,
        'image':
            'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Smokehouse BBQ Burger',
        'category': 'Specials',
        'description':
            'Smoked brisket patty with bourbon BBQ sauce, crispy onions, and coleslaw.',
        'price': 289.0,
        'image':
            'https://images.unsplash.com/photo-1553979459-d2229ba7433b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Gourmet Lamb Burger',
        'category': 'Specials',
        'description':
            'Ground lamb patty with mint yogurt sauce, feta cheese, and cucumber.',
        'price': 299.0,
        'image':
            'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Plant-Based Deluxe',
        'category': 'Specials',
        'description':
            'Premium plant-based patty with artisanal vegan cheese and house-made sauces.',
        'price': 259.0,
        'image':
            'https://images.unsplash.com/photo-1520072959219-c595dc870360?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      },
      {
        'name': 'Fusion Burger',
        'category': 'Specials',
        'description':
            'Asian-inspired burger with Gochujang glaze, kimchi slaw, and wasabi mayo.',
        'price': 269.0,
        'image':
            'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'quantity': 0
      }
    ];

    for (var item in dummyItems) {
      await db.insert('FoodItems', item);
    }
  }

  Future<List<FoodItem>> getFoodItemsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FoodItems',
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }

  Future<List<FoodItem>> searchItems(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FoodItems',
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }

  Future<void> updateItemQuantity(int id, int quantity) async {
    final db = await database;
    await db.update(
      'FoodItems',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<FoodItem>> getAllFoodItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('FoodItems');
    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }
}
