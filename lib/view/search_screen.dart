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

  bool _isSearchFocused = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
      if (!_searchFocusNode.hasFocus && _searchQuery.isNotEmpty) {
        _performSearch(_searchQuery);
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantViewModel, CartViewModel>(
      builder: (context, restaurantViewModel, cartViewModel, _) {
        // Show results immediately as user types
        final searchResults = _searchQuery.isNotEmpty
            ? restaurantViewModel.searchItems(_searchQuery)
            : <FoodItem>[];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchHeader(),
                Expanded(
                  child: _isSearchFocused && _searchQuery.isEmpty
                      ? _buildSuggestionsScreen()
                      : _searchQuery.isEmpty
                          ? _buildEmptySearchScreen()
                          : searchResults.isEmpty
                              ? _buildNoResultsScreen()
                              : _buildResultsScreen(searchResults,
                                  restaurantViewModel, cartViewModel),
                ),
                if (cartViewModel.totalItems > 0 && !_isSearchFocused)
                  _buildCartBar(context, cartViewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResultsScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'No results found for "${_searchQuery}"\nTry a different search term',
            style: TextStyle(
              fontFamily: 'FuturaStd',
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/search_icon.png',
            height: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'Search for your favorite food',
            style: TextStyle(
              fontFamily: 'FuturaStd',
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search suggestions',
            style: TextStyle(
              fontFamily: 'FuturaStd',
              color: Color(0xff888888),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _searchSuggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffe6f8ec),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontFamily: 'FuturaStd',
                      color: Color(0xff11B546),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(List<FoodItem> searchResults,
      RestaurantViewModel restaurantViewModel, CartViewModel cartViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Text(
            '${searchResults.length} results for "${_searchQuery}"',
            style: const TextStyle(
              fontFamily: 'FuturaStd',
              color: Color(0xff333333),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: cartViewModel.totalItems > 0 ? 80 : 20),
            itemCount: searchResults.length,
            separatorBuilder: (context, index) => const Divider(
              height: 50,
              color: Color(0xffDDDDDD),
            ),
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.transparent),
              ),
              child: const Image(
                image: AssetImage(
                  'assets/images/back_icon.png',
                ),
                height: 12,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Container(
              height: 44,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color(0xffdddddd),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xff333333), size: 18),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _performSearch,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontFamily: 'FuturaStd',
                          color: Color(0xff888888),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontFamily: 'FuturaStd',
                        color: Color(0xff333333),
                        fontSize: 14,
                      ),
                      onFieldSubmitted: _performSearch,
                    ),
                  ),
                  const Icon(Icons.mic_none,
                      color: Color(0xff333333), size: 20),
                ],
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
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
        const SizedBox(width: 16.0),
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
              const SizedBox(height: 4.0),
              Text(
                item.description,
                style: const TextStyle(
                  fontFamily: 'FuturaStd',
                  color: Color(0xff888888),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20.0),
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffdddddd)),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.remove,
                          size: 16, color: Color(0xffdddddd)),
                      onPressed: () {
                        if (menuIndex >= 0) {
                          // First check if the item exists in cart
                          final existingCartItemIndex = cartViewModel.cartItems
                              .indexWhere((cartItem) =>
                                  cartItem.name ==
                                  restaurantViewModel
                                      .menuItems[menuIndex].name);

                          restaurantViewModel.updateItemQuantity(menuIndex, -1);

                          // If quantity becomes zero after decrement, update cart
                          final updatedItem =
                              restaurantViewModel.menuItems[menuIndex];

                          if (updatedItem.quantity >= 0) {
                            // If item exists in cart, decrease its quantity by 1
                            if (existingCartItemIndex >= 0) {
                              cartViewModel.updateCartItemQuantity(
                                  existingCartItemIndex, -1);

                              // If quantity becomes 0, remove from display
                              if (updatedItem.quantity == 0 &&
                                  existingCartItemIndex >= 0) {
                                cartViewModel
                                    .removeFromCart(existingCartItemIndex);
                              }
                            }
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      menuIndex >= 0
                          ? '${restaurantViewModel.menuItems[menuIndex].quantity}'
                          : '0',
                      style: const TextStyle(
                        fontFamily: 'FuturaStd',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xffe6f8ec),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: const Color(0xff0db647),
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xff0db647),
                      ),
                      onPressed: () {
                        if (menuIndex >= 0) {
                          // First check if item exists in cart
                          final existingCartItemIndex = cartViewModel.cartItems
                              .indexWhere((cartItem) =>
                                  cartItem.name ==
                                  restaurantViewModel
                                      .menuItems[menuIndex].name);

                          final updatedItem =
                              restaurantViewModel.menuItems[menuIndex];
                          restaurantViewModel.updateItemQuantity(menuIndex, 1);

                          // If item already exists in cart, update its quantity
                          if (existingCartItemIndex >= 0) {
                            cartViewModel.updateCartItemQuantity(
                                existingCartItemIndex, 1);
                          } else {
                            // Create a new cart item with quantity 1
                            final itemToAdd = FoodItem(
                              name: updatedItem.name,
                              description: updatedItem.description,
                              price: updatedItem.price,
                              imageUrl: updatedItem.imageUrl,
                              quantity: 1,
                            );
                            cartViewModel.addToCart(itemToAdd);
                          }
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
    );
  }

  Widget _buildCartBar(BuildContext context, CartViewModel cartViewModel) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.cart);
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 30, left: 16, right: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
    );
  }
}
