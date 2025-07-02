import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:teste_offline_first/repositories/local_storage_sqflite.dart';
import 'package:teste_offline_first/model/item_model.dart';

import 'package:teste_offline_first/services/firebase_firestore_service.dart';
import 'package:teste_offline_first/utils/base_controller.dart';
import 'package:uuid/uuid.dart';

class ShoppingListController extends BaseController {
  final LocalStorageRepository local;
  final FirebaseFirestoreService firestore;

  ShoppingListController({required this.local, required this.firestore});
  final nameEC = TextEditingController();
  final valueEC = TextEditingController();
  final qtdEC = TextEditingController();
  final connectivity = Connectivity();

  void clearEC() {
    nameEC.clear();
    valueEC.clear();
    qtdEC.clear();
  }

  final items = ListSignal<Item>([]);

  @override
  Future<void> onInit() async {
    await local.init();
    await _getListBuy();
    connectivityChange();
    listenToFirestore();
  }

  void connectivityChange() {
    connectivity.onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        log(result.toString());
        firestore.syncItem();
      }
    });
  }

  Future<void> listenToFirestore() async {
    firestore.snapshotsListen();
    await _getListBuy();
  }

  Future<void> _getListBuy() async {
    final result = await local.getBuy();
    items.value = result;
  }

  Future<void> addItem() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    final item = Item(
      id: Uuid().v4(),
      name: nameEC.text,
      value: double.parse(valueEC.text),
      qtd: int.parse(qtdEC.text),
      isDone: false,
      isSynced: false,
    );
    items.add(item);
    await local.create(item: item);

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      log(connectivityResult.toString());
      firestore.syncItem();
    }

    clearEC();
  }

  Future<void> checkItem(String id) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    final index = items.value.indexWhere((item) => item.id == id);
    if (index == -1) return;
    items.value[index] = items.value[index].copyWith(
      isDone: !items.value[index].isDone,
    );
    items.value = <Item>[...items.value];
    await local.toggleIsDone(id);
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      log(connectivityResult.toString());
      firestore.syncItem();
    }
  }

  Future<void> deleteItem(String id) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    final index = items.value.indexWhere((item) => item.id == id);
    if (index == -1) return;
    items.value.removeAt(index);

    await local.deleteBuy(id);
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      log(connectivityResult.toString());
      firestore.removeItemSynced(id);
    }
  }
}
