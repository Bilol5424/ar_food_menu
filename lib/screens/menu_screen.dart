import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../widgets/dish_card.dart';
import 'ar_view_screen.dart';

class MenuScreen extends StatelessWidget {
  final String restaurantName;
  final List<Dish> dishes;
  final String? scannedValue;

  const MenuScreen({
    super.key,
    required this.restaurantName,
    required this.dishes,
    this.scannedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurantName)),
      body: ListView(
        children: [
          if (scannedValue != null)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              padding: const EdgeInsets.all(12),
              child: Text(
                'Отсканирован QR: $scannedValue',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Меню',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          for (int i = 0; i < dishes.length; i++)
            DishCard(
              dish: dishes[i],
              onView: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArViewScreen(dishes: dishes, initialIndex: i),
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
