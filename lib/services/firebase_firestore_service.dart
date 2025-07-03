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
      var syncedItem = i.copyWith(isSynced: true);

      await firestore
          .collection('buy')
          .doc(syncedItem.id)
          .set(syncedItem.toMap());
      await repo.markIsSynced(syncedItem.id);
    }
  }

  Future<void> toggleItemFB() async {
    final firestore = FirebaseFirestore.instance;
    final items = await repo.getBuy();
    for (var item in items) {
      await firestore.collection('buy').doc(item.id).set(item.toMap());
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
      for (var e in event.docChanges) {
        final doc = e.doc;
        final data = doc.data();
        if (data == null) continue;
        final item = Item.fromMap(data);

        switch (e.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            await repo.create(item: item);
            break;
          case DocumentChangeType.removed:
            await repo.deleteBuy(item.id);
            break;
        }
      }
    });
  }
}
