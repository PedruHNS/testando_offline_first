import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste_offline_first/model/item_model.dart';

class LocalStorageRepository {
  static Database? _db;

  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'buy_list.db');

    _db = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) {},
      onOpen: (db) {},
      onCreate: (db, version) {
        db.execute('''CREATE TABLE buy (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        qtd INTEGER NOT NULL,
        isDone INTEGER DEFAULT 0,
        isSynced INTEGER DEFAULT 0
        )
        ''');
      },
    );
  }

  Future<void> create({required Item item}) async {
    await _db?.insert(
      'buy',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getBuy() async {
    final list = await _db?.query('buy') ?? [];
    log(list.toString());
    return list.map((e) => Item.fromMap(e)).toList();
  }

  Future<void> toggleIsDone(String id) async {
    final result = await _db?.query(
      'buy',
      columns: ['isDone'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    // verifica se o resultado é diferente de null e nào vazio
    if (result != null && result.isNotEmpty) {
      //verifica o valor atual do atributo isDone
      final currentIsDone = result.first['isDone'] as int? ?? 0;
      //muda o valor
      final newIsDone = currentIsDone == 1 ? 0 : 1;
      await _db?.update(
        'buy',
        {'isDone': newIsDone},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> markIsSynced(String id) async {
    await _db?.update('buy', {'isSynced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Item>> getUnsynced() async {
    final list =
        await _db?.query('buy', where: 'isSynced = ?', whereArgs: [0]) ?? [];
    return list.map((e) => Item.fromMap(e)).toList();
  }

  Future<void> deleteBuy(String id) async {
    await _db?.delete('buy', where: 'id = ?', whereArgs: [id]);
  }
}
