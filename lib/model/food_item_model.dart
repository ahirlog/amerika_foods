class FoodItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
  });
} 