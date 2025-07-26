import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    print('✅ Environment variables loaded successfully');
  } catch (e) {
    print('⚠️ Warning: Could not load .env file: $e');
    print('⚠️ Make sure the .env file exists and has proper UTF-8 encoding');
  }

  await Firebase.initializeApp();
  configureDependencies();
  //addMenuData(); //todo Uncomment to add initial menu data

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recogenie Restaurant',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

void addMenuData() async {
  final firestore = getIt<FirebaseFirestore>();
  try {
    final menuItems = [
      {
        'name': 'Margherita Pizza',
        'price': 14.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400&h=300&fit=crop',
        'description':
            'Classic tomato sauce with mozzarella cheese and fresh basil',
        'category': 'Pizza',
      },
      {
        'name': 'Pepperoni Pizza',
        'price': 16.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Spicy pepperoni with melted cheese on crispy crust',
        'category': 'Pizza',
      },
      {
        'name': 'Chicken Burger',
        'price': 12.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
        'description':
            'Grilled chicken breast with lettuce, tomato, and special sauce',
        'category': 'Burgers',
      },
      {
        'name': 'Beef Burger',
        'price': 13.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400&h=300&fit=crop',
        'description': 'Juicy beef patty with cheese, lettuce, and onion',
        'category': 'Burgers',
      },
      {
        'name': 'Caesar Salad',
        'price': 9.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop',
        'description':
            'Fresh romaine lettuce with Caesar dressing and croutons',
        'category': 'Salads',
      },
      {
        'name': 'Greek Salad',
        'price': 10.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=300&fit=crop',
        'description':
            'Mixed greens with feta cheese, olives, and Greek dressing',
        'category': 'Salads',
      },
      {
        'name': 'Spaghetti Carbonara',
        'price': 15.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400&h=300&fit=crop',
        'description': 'Pasta with eggs, cheese, pancetta, and black pepper',
        'category': 'Pasta',
      },
      {
        'name': 'Fettuccine Alfredo',
        'price': 14.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1551183053-b3d5c1f1b6c2?w=400&h=300&fit=crop',
        'description': 'Creamy Alfredo sauce with parmesan cheese',
        'category': 'Pasta',
      },
      {
        'name': 'Chocolate Cake',
        'price': 6.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=300&fit=crop',
        'description': 'Rich chocolate cake with chocolate frosting',
        'category': 'Desserts',
      },
      {
        'name': 'Tiramisu',
        'price': 7.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=300&fit=crop',
        'description': 'Italian dessert with coffee-flavored mascarpone cream',
        'category': 'Desserts',
      },
      {
        'name': 'V7 cola',
        'price': 2.99,
        'imageUrl':
            'https://res.cloudinary.com/da7lxmvto/image/upload/v1753517235/597ca5ff-1ca6-4271-8310-9d7bf80cee25_w3fs1c.jpg',
        'description': 'Refreshing carbonated soft drink',
        'category': 'Beverages',
      },
      {
        'name': 'Orange Juice',
        'price': 3.99,
        'imageUrl':
            'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=300&fit=crop',
        'description': 'Fresh squeezed orange juice',
        'category': 'Beverages',
      },
    ];

    for (final item in menuItems) {
      await firestore.collection('menu').add(item);
      print('Added: ${item['name']}');
    }
    print(
      '\n✅ Successfully added ${menuItems.length} menu items to Firestore!',
    );
  } catch (e) {
    print('Error initializing Firestore: $e');
    return;
  }
}
