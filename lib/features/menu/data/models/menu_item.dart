import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? category;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.category,
  });

  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'],
      description: data['description'],
      category: data['category'],
    );
  }
}
