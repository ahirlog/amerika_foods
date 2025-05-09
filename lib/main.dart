import 'package:flutter/material.dart';
import 'package:flutter_notes/utils/routes/routes.dart';
import 'package:flutter_notes/utils/routes/routes_name.dart';
import 'package:flutter_notes/view_model/cart_view_model.dart';
import 'package:flutter_notes/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amerika Foods',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          fontFamily: 'FuturaStd',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.w500),
            titleMedium: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.w500),
            titleSmall: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontFamily: 'FuturaStd'),
            bodyMedium: TextStyle(fontFamily: 'FuturaStd'),
            bodySmall: TextStyle(fontFamily: 'FuturaStd'),
            labelLarge: TextStyle(fontFamily: 'FuturaStd', fontWeight: FontWeight.w500),
            labelMedium: TextStyle(fontFamily: 'FuturaStd'),
            labelSmall: TextStyle(fontFamily: 'FuturaStd'),
          ),
        ),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
