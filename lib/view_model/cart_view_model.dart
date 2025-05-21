import 'package:flutter/foundation.dart';
import 'package:flutter_notes/model/food_item_model.dart';
import 'package:flutter_notes/view_model/restaurant_view_model.dart';

class CartViewModel with ChangeNotifier {
  final List<FoodItem> _cartItems = [];
  RestaurantViewModel? _restaurantViewModel;

  void linkRestaurantViewModel(RestaurantViewModel restaurantViewModel) {
    _restaurantViewModel = restaurantViewModel;
  }

  List<FoodItem> get cartItems => _cartItems;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(FoodItem item) {
    // Don't add items with zero or negative quantity
    if (item.quantity <= 0) {
      // If trying to add an item with 0 quantity, it might be a removal
      final existingIndex =
          _cartItems.indexWhere((element) => element.name == item.name);
      if (existingIndex >= 0) {
        _cartItems.removeAt(existingIndex);
        notifyListeners();
      }
      return;
    }

    final existingIndex =
        _cartItems.indexWhere((element) => element.name == item.name);

    if (existingIndex >= 0) {
      // Just add exactly the new quantity (usually 1) to existing
      _cartItems[existingIndex].quantity =
          _cartItems[existingIndex].quantity + item.quantity;
    } else {
      final cartItem = FoodItem(
        id: item.id,
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: item.quantity,
        category: item.category,
      );
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }

  void updateCartItemQuantity(int index, int change) {
    if (index >= 0 && index < _cartItems.length) {
      final newQuantity = _cartItems[index].quantity + change;
      final itemName = _cartItems[index].name;

      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
        // Sync with restaurant view model
        _syncWithRestaurantViewModel(itemName, 0);
      } else {
        _cartItems[index].quantity = newQuantity;

        // Sync with restaurant view model
        _syncWithRestaurantViewModel(itemName, newQuantity);
      }

      notifyListeners();
    }
  }

  // Direct method to remove an item from cart by index
  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      final itemName = _cartItems[index].name;
      _cartItems.removeAt(index);

      // Sync with restaurant view model
      _syncWithRestaurantViewModel(itemName, 0);

      notifyListeners();
    }
  }

  void clearCart() {
    // Store all item names before clearing
    final itemNames = _cartItems.map((item) => item.name).toList();

    _cartItems.clear();

    // Sync with restaurant view model for all cleared items
    for (final name in itemNames) {
      _syncWithRestaurantViewModel(name, 0);
    }

    notifyListeners();
  }

  // Helper method to sync item quantities with the restaurant view model
  void _syncWithRestaurantViewModel(String itemName, int quantity) {
    if (_restaurantViewModel != null) {
      // Find the item in the restaurant view model's full menuItems list
      final index = _restaurantViewModel!.menuItems
          .indexWhere((item) => item.name == itemName);
      if (index >= 0) {
        // Update the quantity in the restaurant view model without notifying
        _restaurantViewModel!.setItemQuantityWithoutNotifying(index, quantity);
      }
    }
  }
}
