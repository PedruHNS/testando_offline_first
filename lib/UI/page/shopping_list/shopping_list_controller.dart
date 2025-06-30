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
    items.add(item);
    await LocalStorageSQFLITE.create(item: item);
    clearEC();
  }

  Future<void> checkItem(String id) async {
    final index = items.value.indexWhere((item) => item.id == id);
    if (index == -1) return;
    items.value[index] = items.value[index].copyWith(
      isDone: !items.value[index].isDone,
    );
    items.value = <Item>[...items.value];
    await LocalStorageSQFLITE.toggleIsDone(id);
  }

  Future<void> deleteItem(String id) async {
    final index = items.value.indexWhere((item) => item.id == id);
    if (index == -1) return;
    items.value.removeAt(index);

    await LocalStorageSQFLITE.deleteBuy(id);
  }
}
