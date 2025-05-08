import 'package:flutter/material.dart';
import 'package:flutter_notes/utils/routes/routes_name.dart';
import 'package:flutter_notes/view/cart_screen.dart';
import 'package:flutter_notes/view/home_screen.dart';
import 'package:flutter_notes/view/restaurant_screen.dart';
import 'package:flutter_notes/view/search_screen.dart';
import 'package:flutter_notes/view/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.restaurant:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RestaurantScreen());
      case RoutesName.search:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchScreen());
      case RoutesName.cart:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CartScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
} 