import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<FoodItem> _foodItems = [
    FoodItem(
      name: 'Chicken Slab Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 259,
      image: 'assets/burger1.jpg',
    ),
    FoodItem(
      name: 'Chicken Crunch Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 209,
      image: 'assets/burger2.jpg',
    ),
    FoodItem(
      name: 'Donut Header Chicken',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 199,
      image: 'assets/burger3.jpg',
    ),
    FoodItem(
      name: 'Mighty Chicken Patty Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 209,
      image: 'assets/burger4.jpg',
    ),
    FoodItem(
      name: 'Chicken Crunch Burger',
      description: 'It is a long established fact that a reader will be distracted.',
      price: 209,
      image: 'assets/burger2.jpg',
    ),
  ];

  final List<String> _searchSuggestions = ['Burgers', 'Chicken', 'Fries', 'Beverages', 'Sides', 'Desserts'];
  bool _isSearching = false;
  String _searchQuery = "Chicken";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _searchQuery;
  }

  int get _totalItemsInCart => _foodItems.fold(0, (sum, item) => sum + item.quantity);
  double get _totalPrice => _foodItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _updateQuantity(int index, int change) {
    setState(() {
      int newQuantity = _foodItems[index].quantity + change;
      if (newQuantity >= 0) {
        _foodItems[index].quantity = newQuantity;
      }
    });
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _isSearching
                ? _buildSearchScreen()
                : _buildResultsScreen(),
            if (_totalItemsInCart > 0 && !_isSearching)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildCartBar(),
              ),
          ],
        ),
      ),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    suggestion,
                    style: TextStyle(
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

  Widget _buildResultsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '12 Search results...',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: _totalItemsInCart > 0 ? 80 : 20),
            itemCount: _foodItems.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildFoodItem(index);
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
          GestureDetector(
            onTap: _isSearching ? _exitSearch : () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black87),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: _isSearching
                          ? TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        onSubmitted: _performSearch,
                      )
                          : Text(
                        _searchQuery,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.mic, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(int index) {
    final item = _foodItems[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      '₹ ${item.price.toInt()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.remove, size: 18),
                        onPressed: () {
                          _updateQuantity(index, -1);
                        },
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.add, size: 18, color: Colors.white),
                        onPressed: () {
                          _updateQuantity(index, 1);
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

  Widget _buildCartBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$_totalItemsInCart ${_totalItemsInCart == 1 ? 'item' : 'items'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12.0),
          Text(
            '₹ ${_totalPrice.toInt()}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              // Navigate to cart page
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
            child: Text(
              'View cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final double price;
  final String image;
  int quantity;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.quantity = 0,
  });
}
