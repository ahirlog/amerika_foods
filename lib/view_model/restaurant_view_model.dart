import 'package:flutter/foundation.dart';
import 'package:flutter_notes/model/food_item_model.dart';

class RestaurantViewModel with ChangeNotifier {
  final List<FoodItem> _menuItems = [
    FoodItem(
      name: 'Chicken Slab Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 259,
      imageUrl: 'https://via.placeholder.com/200',
    ),
    FoodItem(
      name: 'Chicken Crunch Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 209,
      imageUrl: 'https://via.placeholder.com/200',
    ),
    FoodItem(
      name: 'Donut Header Chicken',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 199,
      imageUrl: 'https://via.placeholder.com/200',
    ),
    FoodItem(
      name: 'Mighty Chicken Patty Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 209,
      imageUrl: 'https://via.placeholder.com/200',
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
    return _menuItems.where((item) => 
      item.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
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
} 