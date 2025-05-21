import 'package:flutter/foundation.dart';
import 'package:flutter_notes/data/local/database_helper.dart';
import 'package:flutter_notes/model/food_item_model.dart';

class RestaurantViewModel with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<FoodItem> _menuItems = [];
  String _currentCategory = 'Recommended';
  bool _isLoading = false;
  String _error = '';
  bool _isInSearchMode = false;

  RestaurantViewModel() {
    _loadAllItems();
  }

  String _getFixedImageUrl(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return imageUrl;
    }
    
    try {
      Uri.parse(imageUrl);
      return imageUrl;
    } catch (e) {
      return 'assets/images/food/default_food.png';
    }
  }

  FoodItem _fixFoodItemImage(FoodItem item) {
    return FoodItem(
      id: item.id,
      name: item.name,
      category: item.category,
      description: item.description,
      price: item.price,
      imageUrl: _getFixedImageUrl(item.imageUrl),
      quantity: item.quantity,
    );
  }

  Future<void> _loadAllItems() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final items = await _databaseHelper.getAllFoodItems();
      _menuItems = items.map((item) => _fixFoodItemImage(item)).toList();
      
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
      _isInSearchMode = false;
      _currentCategory = category;
      notifyListeners();

      final items = await _databaseHelper.getFoodItemsByCategory(category);

      final Map<String, int> itemQuantities = {};
      for (var item in _menuItems) {
        if (item.quantity > 0) {
          itemQuantities[item.name] = item.quantity;
        }
      }

      _menuItems = items.map((item) {
        final fixedItem = _fixFoodItemImage(item);
        if (itemQuantities.containsKey(fixedItem.name)) {
          return FoodItem(
            id: fixedItem.id,
            name: fixedItem.name,
            category: fixedItem.category,
            description: fixedItem.description,
            price: fixedItem.price,
            imageUrl: fixedItem.imageUrl,
            quantity: itemQuantities[fixedItem.name] ?? 0,
          );
        }
        return fixedItem;
      }).toList();
      
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
      _isInSearchMode = true;
      notifyListeners();

      List<FoodItem> items;
      if (query.isEmpty) {
        items = await _databaseHelper.getAllFoodItems();
      } else {
        items = await _databaseHelper.searchItems(query);
      }

      final Map<String, int> itemQuantities = {};
      for (var item in _menuItems) {
        if (item.quantity > 0) {
          itemQuantities[item.name] = item.quantity;
        }
      }
      
      _menuItems = items.map((item) {
        final fixedItem = _fixFoodItemImage(item);
        if (itemQuantities.containsKey(fixedItem.name)) {
          return FoodItem(
            id: fixedItem.id,
            name: fixedItem.name,
            category: fixedItem.category,
            description: fixedItem.description,
            price: fixedItem.price,
            imageUrl: fixedItem.imageUrl,
            quantity: itemQuantities[fixedItem.name] ?? 0,
          );
        }
        return fixedItem;
      }).toList();
      
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

  void restoreOriginalItems() {
    if (_isInSearchMode) {
      _isInSearchMode = false;
      fetchItemsByCategory(_currentCategory);
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
  bool get isInSearchMode => _isInSearchMode;
}
