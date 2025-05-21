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
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = [
    'Recommended',
    'Combos',
    'Regular Burgers',
    'Specials'
  ];
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      final restaurantViewModel = Provider.of<RestaurantViewModel>(context, listen: false);
      cartViewModel.linkRestaurantViewModel(restaurantViewModel);
      
      // Fetch initial items
      restaurantViewModel.fetchItemsByCategory(_categories[_selectedTabIndex]);
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFirstBuild) {
      // Refresh data when returning to this screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final restaurantViewModel = Provider.of<RestaurantViewModel>(context, listen: false);

        restaurantViewModel.fetchItemsByCategory(_categories[_selectedTabIndex]);
      });
    }
    _isFirstBuild = false;
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    Provider.of<RestaurantViewModel>(context, listen: false)
        .fetchItemsByCategory(_categories[index]);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

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
                    'https://cdn.pixabay.com/photo/2022/09/30/20/15/fries-7490192_1280.jpg',
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
                    top: 54,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: 32,
                              height: 32,
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/back_icon.png',
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.search);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  width: 32,
                                  height: 32,
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/images/search_icon.png',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: 32,
                                height: 32,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/share_icon.png',
                                  ),
                                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amerika Foods',
                              style: TextStyle(
                                fontFamily: 'FuturaStd',
                                color: Color(0xff333333),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'American, Fast Food, Burgers',
                              style: TextStyle(
                                fontFamily: 'FuturaStd',
                                color: Color(0xff888888),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xffDDDDDD)),
                          ),
                          width: 32,
                          height: 32,
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 17),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            ' 4.5',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: 'FuturaStd',
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 16,
                          width: 1,
                          color: const Color(0xffDDDDDD),
                        ),
                        const Row(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/Chat_icon.png',
                              ),
                              height: 16,
                            ),
                            Text(
                              ' 1K+ reviews',
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontFamily: 'FuturaStd',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 16,
                          width: 1,
                          color: const Color(0xffDDDDDD),
                        ),
                        const Row(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/clock_icon.png',
                              ),
                              height: 15,
                            ),
                            Text(
                              ' 15 mins',
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontFamily: 'FuturaStd',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                height: 1,
                width: double.infinity,
                color: const Color(0xffDDDDDD),
              ),

              // Tab Bar
              SizedBox(
                height: 30.5,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 7),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _onCategorySelected(index), // Call the new method
                      child: SizedBox(
                        width: 110,
                        child: Column(
                          children: [
                            Text(
                              _categories[index],
                              style: TextStyle(
                                fontFamily: 'FuturaStd',
                                color: _selectedTabIndex == index
                                    ? const Color(0xff11B546)
                                    : const Color(0xff888888),
                                fontWeight: _selectedTabIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 2.5,
                              width: _categories[index].length * 8, // Dynamic width based on text length
                              color: _selectedTabIndex == index
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(
                height: 1,
                indent: 16,
              ),

              // Menu Items
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  itemCount: restaurantViewModel.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = restaurantViewModel.menuItems[index];
                    return _buildFoodItem(context, item, index,
                        restaurantViewModel, cartViewModel);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 50,
                    color: Color(0xffDDDDDD),
                  ),
                ),
              ),

              // Cart Bar
              if (cartViewModel.totalItems > 0)
                SafeArea(
                  top: false,
                  bottom: true,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.cart);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${cartViewModel.totalItems} ${cartViewModel.totalItems == 1 ? 'item' : 'items'}',
                            style: const TextStyle(
                              fontFamily: 'FuturaStd',
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            height: 16,
                            width: 1,
                            color: const Color(0xffDDDDDD),
                          ),
                          Text(
                            '₹ ${cartViewModel.totalPrice.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'FuturaStd',
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xff11B546),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 93,
                            height: 44,
                            child: const Center(
                              child: Text(
                                'View cart',
                                style: TextStyle(
                                  fontFamily: 'FuturaStd',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodItem(BuildContext context, FoodItem item, int index,
      RestaurantViewModel restaurantViewModel, CartViewModel cartViewModel) {
    // Check if the item is already in the cart to show initial quantity
    final cartItem = cartViewModel.cartItems.firstWhere(
      (cartItm) => cartItm.name == item.name,
      orElse: () => FoodItem(
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: 0,
        category: item.category, // Pass category here
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Food Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: 120,
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
                  fontFamily: 'FuturaStd',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: const TextStyle(
                  fontFamily: 'FuturaStd',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff888888),
                ),
              ),
              const SizedBox(height: 20),

              // Price and Quantity Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${item.price.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'FuturaStd',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          cartViewModel.updateCartItemQuantity(
                              cartViewModel.cartItems.indexWhere(
                                  (element) => element.name == item.name),
                              -1);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xffdddddd),
                            ),
                          ),
                          child: const Icon(
                            size: 16,
                            Icons.remove,
                            color: Color(0xffdddddd),
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        alignment: Alignment.center,
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontFamily: 'FuturaStd',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Find if the item already exists in the cart
                          final existingCartItemIndex = cartViewModel.cartItems
                              .indexWhere(
                                  (element) => element.name == item.name);

                          if (existingCartItemIndex >= 0) {
                            // If it exists, just update its quantity
                            cartViewModel.updateCartItemQuantity(
                                existingCartItemIndex, 1);
                          } else {
                            // Create a new cart item with quantity 1
                            final itemToAdd = FoodItem(
                              id: item.id,
                              // Pass ID
                              name: item.name,
                              description: item.description,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              quantity: 1,
                              category: item.category, // Pass category
                            );
                            cartViewModel.addToCart(itemToAdd);
                          }
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xffe6f8ec),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xff0db647),
                            ),
                          ),
                          child: const Icon(
                            size: 16,
                            Icons.add,
                            color: Color(0xff0db647),
                          ),
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
    );
  }
}
