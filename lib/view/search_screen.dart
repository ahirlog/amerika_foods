import 'package:flutter/material.dart';
import 'package:flutter_notes/model/food_item_model.dart';
import 'package:flutter_notes/utils/routes/routes_name.dart';
import 'package:flutter_notes/view_model/cart_view_model.dart';
import 'package:flutter_notes/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _searchSuggestions = [
    'Burgers',
    'Chicken',
    'Fries',
    'Beverages',
    'Sides',
    'Desserts'
  ];
  bool _isSearching = false;
  String _searchQuery = "Chicken";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _searchQuery;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _exitSearch() {
    setState(() {
      _isSearching = false;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantViewModel, CartViewModel>(
      builder: (context, restaurantViewModel, cartViewModel, _) {
        final searchResults = restaurantViewModel.searchItems(_searchQuery);

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                _isSearching
                    ? _buildSearchScreen()
                    : _buildResultsScreen(
                        searchResults, restaurantViewModel, cartViewModel),
                if (cartViewModel.totalItems > 0 && !_isSearching)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildCartBar(context, cartViewModel),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchHeader(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Search recommendations',
            style: TextStyle(
              fontFamily: 'FuturaStd',
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _searchSuggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _performSearch(suggestion);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontFamily: 'FuturaStd',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen(List<FoodItem> searchResults,
      RestaurantViewModel restaurantViewModel, CartViewModel cartViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '${searchResults.length} Search results...',
            style: const TextStyle(
              fontFamily: 'FuturaStd',
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding:
                EdgeInsets.only(bottom: cartViewModel.totalItems > 0 ? 80 : 20),
            itemCount: searchResults.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildFoodItem(
                  index, searchResults, restaurantViewModel, cartViewModel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Image(
              image: AssetImage(
                'assets/images/back_icon.png',
              ),
              height: 12,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color(0xffdddddd),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xff333333)),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: _isSearching
                          ? TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0),
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontFamily: 'FuturaStd',
                                ),
                              ),
                              onSubmitted: _performSearch,
                            )
                          : Text(
                              _searchQuery,
                              style: const TextStyle(
                                fontFamily: 'FuturaStd',
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                    ),
                    const Icon(Icons.mic_none, color: Color(0xff333333)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(int index, List<FoodItem> items,
      RestaurantViewModel restaurantViewModel, CartViewModel cartViewModel) {
    final item = items[index];
    final menuIndex = restaurantViewModel.menuItems
        .indexWhere((menuItem) => menuItem.name == item.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
                onError: (_, __) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'FuturaStd',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.description,
                  style: TextStyle(
                    fontFamily: 'FuturaStd',
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      '₹ ${item.price.toInt()}',
                      style: const TextStyle(
                        fontFamily: 'FuturaStd',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (menuIndex >= 0) {
                            restaurantViewModel.updateItemQuantity(
                                menuIndex, -1);

                            // If quantity becomes zero after decrement, update cart
                            final updatedItem =
                                restaurantViewModel.menuItems[menuIndex];
                            if (updatedItem.quantity >= 0) {
                              cartViewModel.addToCart(updatedItem);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      menuIndex >= 0
                          ? '${restaurantViewModel.menuItems[menuIndex].quantity}'
                          : '0',
                      style: const TextStyle(
                        fontFamily: 'FuturaStd',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add,
                            size: 18, color: Colors.white),
                        onPressed: () {
                          if (menuIndex >= 0) {
                            restaurantViewModel.updateItemQuantity(
                                menuIndex, 1);

                            // Update cart
                            final updatedItem =
                                restaurantViewModel.menuItems[menuIndex];
                            cartViewModel.addToCart(updatedItem);
                          }
                        },
                      ),
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

  Widget _buildCartBar(BuildContext context, CartViewModel cartViewModel) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.cart);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        child: Row(
          children: [
            Text(
              '${cartViewModel.totalItems} ${cartViewModel.totalItems == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                fontFamily: 'FuturaStd',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              '₹ ${cartViewModel.totalPrice.toInt()}',
              style: const TextStyle(
                fontFamily: 'FuturaStd',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Text(
              'View cart',
              style: TextStyle(
                fontFamily: 'FuturaStd',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
    );
  }
}
