import 'package:flutter/foundation.dart';
import 'package:flutter_notes/model/food_item_model.dart';

class CartViewModel with ChangeNotifier {
  final List<FoodItem> _cartItems = [];

  List<FoodItem> get cartItems => _cartItems;
  
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  
  void addToCart(FoodItem item) {
    if (item.quantity <= 0) return;
    
    final existingIndex = _cartItems.indexWhere((element) => element.name == item.name);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += item.quantity;
    } else {
      final cartItem = FoodItem(
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: item.quantity,
      );
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }
  
  void updateCartItemQuantity(int index, int change) {
    if (index >= 0 && index < _cartItems.length) {
      final newQuantity = _cartItems[index].quantity + change;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
} 