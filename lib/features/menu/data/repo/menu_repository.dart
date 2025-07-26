import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/menu_item.dart';

@injectable
class MenuRepository {
  final FirebaseFirestore _firestore;
  MenuRepository(this._firestore);

  Future<List<MenuItem>> fetchMenuItems() async {
    final snapshot = await _firestore.collection('menu').get();
    return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
  }
}
