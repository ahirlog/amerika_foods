import 'package:flutter/material.dart';
import 'package:flutter_notes/model/food_item_model.dart';
import 'package:flutter_notes/view_model/cart_view_model.dart';
import 'package:flutter_notes/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'FuturaStd',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer2<CartViewModel, RestaurantViewModel>(
        builder: (context, cartViewModel, restaurantViewModel, _) {
          if (cartViewModel.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                    fontFamily: 'FuturaStd', fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartViewModel.cartItems.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cartViewModel.cartItems[index];
                    return _buildCartItem(context, item, index, cartViewModel,
                        restaurantViewModel);
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, cartViewModel, _) {
          if (cartViewModel.cartItems.isEmpty) {
            return Container(height: 0);
          }
          return _buildCartSummary(context, cartViewModel);
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, FoodItem item, int index,
      CartViewModel cartViewModel, RestaurantViewModel restaurantViewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontFamily: 'FuturaStd',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹ ${item.price.toInt()}',
                style: const TextStyle(
                  fontFamily: 'FuturaStd',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                cartViewModel.updateCartItemQuantity(index, -1);
              },
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(
                fontFamily: 'FuturaStd',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                cartViewModel.updateCartItemQuantity(index, 1);
              },
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartViewModel cartViewModel) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Order summary section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontFamily: 'FuturaStd',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Items Total',
                        style: TextStyle(fontFamily: 'FuturaStd')),
                    Text('₹ ${cartViewModel.totalPrice.toInt()}',
                        style: const TextStyle(fontFamily: 'FuturaStd')),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee',
                        style: TextStyle(fontFamily: 'FuturaStd')),
                    Text('₹ 40',
                        style: TextStyle(fontFamily: 'FuturaStd')),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'To Pay',
                      style: TextStyle(
                        fontFamily: 'FuturaStd',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹ ${(cartViewModel.totalPrice + 40).toInt()}',
                      style: const TextStyle(
                        fontFamily: 'FuturaStd',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom navigation bar with Place Order button
          BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.green,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'FuturaStd',
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'FuturaStd',
              fontWeight: FontWeight.bold,
            ),
            onTap: (index) {
              // Place order functionality
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Order Details',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_forward),
                label: 'Place Order',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
