import 'package:flutter/foundation.dart';
import 'package:flutter_notes/data/local/database_helper.dart';
import 'package:flutter_notes/model/food_item_model.dart';

class RestaurantViewModel with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<FoodItem> _menuItems = [];
  bool _isLoading = false;
  String _error = '';

  RestaurantViewModel() {
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _menuItems = await _databaseHelper.getAllFoodItems();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _menuItems = [];
      notifyListeners();
    }
  }

  List<FoodItem> get menuItems => _menuItems;

  Future<void> fetchItemsByCategory(String category) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _menuItems = await _databaseHelper.getFoodItemsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _menuItems = [];
      notifyListeners();
    }
  }

  Future<List<FoodItem>> searchItems(String query) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      if (query.isEmpty) {
        _menuItems = await _databaseHelper.getAllFoodItems();
      } else {
        _menuItems = await _databaseHelper.searchItems(query);
      }
      
      _isLoading = false;
      notifyListeners();
      return _menuItems;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _menuItems = [];
      notifyListeners();
      return [];
    }
  }

  Future<void> updateItemQuantity(int index, int change) async {
    if (index >= 0 && index < _menuItems.length) {
      final item = _menuItems[index];
      final newQuantity = item.quantity + change;
      
      if (newQuantity >= 0) {
        try {
          await _databaseHelper.updateItemQuantity(item.id!, newQuantity);
          _menuItems[index] = FoodItem(
            id: item.id,
            name: item.name,
            category: item.category,
            description: item.description,
            price: item.price,
            imageUrl: item.imageUrl,
            quantity: newQuantity,
          );
          notifyListeners();
        } catch (e) {
          _error = e.toString();
          notifyListeners();
        }
      }
    }
  }

  void setItemQuantityWithoutNotifying(int index, int quantity) {
    if (index >= 0 && index < _menuItems.length) {
      _menuItems[index] = FoodItem(
        id: _menuItems[index].id,
        name: _menuItems[index].name,
        category: _menuItems[index].category,
        description: _menuItems[index].description,
        price: _menuItems[index].price,
        imageUrl: _menuItems[index].imageUrl,
        quantity: quantity,
      );
    }
  }

  bool get isLoading => _isLoading;
  String get error => _error;
}
