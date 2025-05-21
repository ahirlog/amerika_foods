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
  List<FoodItem> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late RestaurantViewModel _restaurantViewModel;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchChanged);
    
    // Request focus when the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restaurantViewModel = Provider.of<RestaurantViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    
    // Now use the already stored reference
    if (_restaurantViewModel.isInSearchMode) {
      _restaurantViewModel.restoreOriginalItems();
    }
    
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      // Perform search as user types
      _performSearch(_searchQuery);
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

  Future<void> _performSearch(String query) async {
    _searchResults = await _restaurantViewModel.searchItems(query);
    setState(() {}); // Update UI with search results
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantViewModel, CartViewModel>(
      builder: (context, restaurantViewModel, cartViewModel, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchHeader(cartViewModel),
                Expanded(
                  child: _isSearchFocused && _searchQuery.isEmpty
                      ? _buildSuggestionsScreen()
                      : _searchQuery.isEmpty
                      ? _buildEmptySearchScreen()
                      : _searchResults.isEmpty
                      ? _buildNoResultsScreen()
                      : _buildResultsScreen(_searchResults,
                      restaurantViewModel, cartViewModel),
                ),
                if (cartViewModel.totalItems > 0)
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

  Widget _buildSearchHeader(CartViewModel cartViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _restaurantViewModel.restoreOriginalItems();

              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: _isSearchFocused ? const Color(0xff11B546) : const Color(0xffdddddd),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search, 
                    color: _isSearchFocused ? const Color(0xff11B546) : const Color(0xff333333), 
                    size: 18
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _searchFocusNode.requestFocus();
                      },
                      child: TextFormField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          _performSearch(value);
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            fontFamily: 'FuturaStd',
                            color: Color(0xff888888),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _performSearch('');
                                  },
                                )
                              : null,
                        ),
                        style: TextStyle(
                          fontFamily: 'FuturaStd',
                          color: _isSearchFocused ? const Color(0xff11B546) : const Color(0xff333333),
                          fontSize: 14,
                        ),
                        onFieldSubmitted: _performSearch,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.mic_none,
                    color: _isSearchFocused ? const Color(0xff11B546) : const Color(0xff333333), 
                    size: 20
                  ),
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
    // Check if the item is already in the cart to show initial quantity
    final cartItem = cartViewModel.cartItems.firstWhere(
          (cartItm) => cartItm.name == item.name,
      orElse: () => FoodItem(
        id: item.id,
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: 0,
        category: item.category,
      ),
    );

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
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          cartViewModel.updateCartItemQuantity(
                              cartViewModel.cartItems.indexWhere(
                                      (element) => element.name == item.name),
                              -1);
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.remove,
                              size: 16, color: Color(0xff0db647)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontFamily: 'FuturaStd',
                            color: Color(0xff333333),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          final existingCartItemIndex =
                          cartViewModel.cartItems.indexWhere(
                                  (element) => element.name == item.name);

                          if (existingCartItemIndex >= 0) {
                            cartViewModel.updateCartItemQuantity(
                                existingCartItemIndex, 1);
                          } else {
                            final itemToAdd = FoodItem(
                              id: item.id,
                              name: item.name,
                              description: item.description,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              quantity: 1,
                              category: item.category,
                            );
                            cartViewModel.addToCart(itemToAdd);
                          }

                          setState(() {});
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

  Widget _buildCartBar(BuildContext context, CartViewModel cartViewModel) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.cart);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
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
