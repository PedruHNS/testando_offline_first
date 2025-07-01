import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste_offline_first/model/item_model.dart';
import 'package:teste_offline_first/repositories/local_storage_sqflite.dart';

class FirebaseFirestoreService {
  final LocalStorageRepository repo;

  FirebaseFirestoreService(this.repo);

  Future<void> syncItem() async {
    final firestore = FirebaseFirestore.instance;
    final unsynced = await repo.getUnsynced();
    for (var i in unsynced) {
      await firestore.collection('buy').doc(i.id).set(i.toMap());
      await repo.markIsSynced(i.id);
    }
  }
}
