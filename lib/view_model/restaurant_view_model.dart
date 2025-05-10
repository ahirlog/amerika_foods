import 'package:flutter/foundation.dart';
import 'package:flutter_notes/model/food_item_model.dart';

class RestaurantViewModel with ChangeNotifier {
  final List<FoodItem> _menuItems = [
    FoodItem(
      name: 'Chicken Slab Burger',
      description: 'Juicy chicken slab with fresh veggies and sauce.',
      price: 259,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Chicken Crunch Burger',
      description: 'Crispy chicken patty with lettuce and mayo.',
      price: 209,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Donut Header Chicken',
      description: 'Chicken burger with a sweet donut bun.',
      price: 199,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'Mighty Chicken Patty Burger',
      description: 'Double chicken patty with cheese and sauce.',
      price: 209,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Classic Beef Burger',
      description: 'Beef patty, cheddar cheese, and pickles.',
      price: 249,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Veggie Delight',
      description: 'Grilled veggie patty with fresh greens.',
      price: 179,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'Spicy Paneer Burger',
      description: 'Paneer patty with spicy sauce and onions.',
      price: 189,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Fish Fillet Burger',
      description: 'Crispy fish fillet with tartar sauce.',
      price: 229,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Egg & Cheese Burger',
      description: 'Egg patty, cheese, and tomato.',
      price: 169,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'BBQ Chicken Burger',
      description: 'Grilled chicken with BBQ sauce.',
      price: 219,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Cheese Burst Burger',
      description: 'Loaded with extra cheese and jalapenos.',
      price: 199,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Double Decker Burger',
      description: 'Two patties, double the fun.',
      price: 279,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'Peri Peri Chicken Burger',
      description: 'Spicy peri peri chicken with lettuce.',
      price: 229,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Aloo Tikki Burger',
      description: 'Indian style potato patty burger.',
      price: 149,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Grilled Lamb Burger',
      description: 'Tender lamb patty with mint sauce.',
      price: 269,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'Crispy Corn Burger',
      description: 'Corn and cheese patty, crunchy and tasty.',
      price: 179,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Hawaiian Chicken Burger',
      description: 'Chicken, pineapple, and tangy sauce.',
      price: 239,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
    FoodItem(
      name: 'Mushroom Swiss Burger',
      description: 'Mushrooms, Swiss cheese, and beef patty.',
      price: 259,
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/08/31/10/17/hamburger-7422968_1280.jpg',
    ),
    FoodItem(
      name: 'Falafel Burger',
      description: 'Middle Eastern falafel patty with tahini.',
      price: 189,
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/10/25/04/27/burger-8339491_1280.jpg',
    ),
    FoodItem(
      name: 'Buffalo Chicken Burger',
      description: 'Spicy buffalo chicken and ranch.',
      price: 219,
      imageUrl:
          'https://cdn.pixabay.com/photo/2021/05/22/01/25/hamburger-6272342_1280.jpg',
    ),
  ];

  List<FoodItem> get menuItems => _menuItems;

  List<FoodItem> getItemsByCategory(String category) {
    return _menuItems;
  }

  List<FoodItem> searchItems(String query) {
    if (query.isEmpty) {
      return _menuItems;
    }
    return _menuItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateItemQuantity(int index, int change) {
    if (index >= 0 && index < _menuItems.length) {
      final newQuantity = _menuItems[index].quantity + change;
      if (newQuantity >= 0) {
        _menuItems[index].quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  void resetQuantities() {
    for (var item in _menuItems) {
      item.quantity = 0;
    }
    notifyListeners();
  }

  // Sets the quantity of an item at the given index without notifying listeners
  void setItemQuantityWithoutNotifying(int index, int quantity) {
    if (index >= 0 && index < _menuItems.length) {
      _menuItems[index].quantity = quantity;
    }
  }
}
