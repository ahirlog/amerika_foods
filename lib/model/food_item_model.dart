// lib/model/food_item_model.dart
class FoodItem {
  final int? id; // Nullable for new items before insertion into DB
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;

  FoodItem({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'image': imageUrl,
      'quantity': quantity,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['image'],
      quantity: map['quantity'] ?? 0,
    );
  }
}
