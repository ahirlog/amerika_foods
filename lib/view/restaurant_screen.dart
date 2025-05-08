import 'package:flutter/material.dart';
import 'package:flutter_notes/model/food_item_model.dart';
import 'package:flutter_notes/utils/routes/routes_name.dart';
import 'package:flutter_notes/view_model/cart_view_model.dart';
import 'package:flutter_notes/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _selectedTabIndex = 0;
  final List<String> _categories = ['Recommended', 'Combos', 'Regular Burgers', 'Specials'];

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantViewModel, CartViewModel>(
      builder: (context, restaurantViewModel, cartViewModel, _) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image with Back, Search and Share buttons
              Stack(
                children: [
                  Image.network(
                    'https://via.placeholder.com/400x200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.arrow_back, color: Colors.black),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, RoutesName.search);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.search, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.share, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Restaurant Info Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amerika Foods',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'American, Fast Food, Burgers',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const Text(
                              ' 4.5',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.chat_bubble_outline, color: Colors.green, size: 16),
                                  Text(
                                    ' 1K+ reviews',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: const [
                                Icon(Icons.access_time, color: Colors.blue, size: 16),
                                Text(' 15 mins'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.favorite_border, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => setState(() => _selectedTabIndex = index),
                      child: Container(
                        width: 120,
                        child: Column(
                          children: [
                            Text(
                              _categories[index],
                              style: TextStyle(
                                color: _selectedTabIndex == index ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 3,
                              width: 80,
                              color: _selectedTabIndex == index ? Colors.green : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: restaurantViewModel.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = restaurantViewModel.menuItems[index];
                    return Column(
                      children: [
                        _buildFoodItem(context, item, index, restaurantViewModel, cartViewModel),
                        const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),

              // Cart Bar
              if (cartViewModel.totalItems > 0)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.cart);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${cartViewModel.totalItems} ${cartViewModel.totalItems == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '₹ ${cartViewModel.totalPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'View cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodItem(
    BuildContext context, 
    FoodItem item, 
    int index, 
    RestaurantViewModel restaurantViewModel,
    CartViewModel cartViewModel
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),

                // Price and Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹ ${item.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            restaurantViewModel.updateItemQuantity(index, -1);
                            
                            // If quantity becomes zero after decrement, update cart
                            if (item.quantity == 0) {
                              cartViewModel.addToCart(item);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.remove, color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: 36,
                          alignment: Alignment.center,
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            restaurantViewModel.updateItemQuantity(index, 1);
                            
                            // If quantity becomes 1 after increment, add to cart
                            if (item.quantity == 1) {
                              cartViewModel.addToCart(item);
                            } else {
                              // Otherwise just update the cart with new quantity
                              cartViewModel.addToCart(item);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green,
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 