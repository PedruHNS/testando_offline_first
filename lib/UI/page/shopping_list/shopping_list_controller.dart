import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:teste_offline_first/core/local_storage_sqflite.dart';
import 'package:teste_offline_first/model/item_model.dart';
import 'package:uuid/uuid.dart';

class ShoppingListController {
  final nameEC = TextEditingController();
  final valueEC = TextEditingController();
  final qtdEC = TextEditingController();

  void clearEC() {
    nameEC.clear();
    valueEC.clear();
    qtdEC.clear();
  }

  final items = ListSignal<Item>([]);

  Future<void> onInit() async {
    await LocalStorageSQFLITE.init();
    await _getListBuy();
  }

  Future<void> _getListBuy() async {
    final result = await LocalStorageSQFLITE.getBuy();
    items.value = result;
  }

  Future<void> addItem() async {
    final item = Item(
      id: Uuid().v4(),
      name: nameEC.text,
      value: double.parse(valueEC.text),
      qtd: int.parse(qtdEC.text),
      isDone: false,
      isSynced: false,
    );

    await LocalStorageSQFLITE.create(item: item);
    items.add(item);
    clearEC();
  }

  Future<void> checkItem(String id) async {
    LocalStorageSQFLITE.toggleIsDone(id);
  }

  Future<void> deleteItem(String id) async {
    LocalStorageSQFLITE.deleteBuy(id);
  }
}
