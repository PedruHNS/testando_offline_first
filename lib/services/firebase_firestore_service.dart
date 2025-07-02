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

  Future<String> removeItemSynced(String id) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('buy').doc(id).delete();
      return 'item deletado com sucesso';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> snapshotsListen() async {
    final firestore = FirebaseFirestore.instance;

    firestore.collection('buy').snapshots().listen((event) async {
      for (var e in event.docs) {
        final item = Item.fromMap(e.data());
        await repo.create(item: item);
      }
    });
  }
}
