import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:teste_offline_first/UI/page/shopping_list/shopping_list_controller.dart';
import 'package:teste_offline_first/UI/widget/adicionar_item_modal.dart';
import 'package:teste_offline_first/UI/widget/card_item.dart';
import 'package:teste_offline_first/repositories/local_storage_sqflite.dart';
import 'package:teste_offline_first/services/firebase_firestore_service.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShoppingListPage> {
  final controller = GetIt.I<ShoppingListController>();

  void _showBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AdicionarItemModal(controller: controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Teste de offline first'),
      ),
      body: Watch((_) {
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (_, index) {
            final item = controller.items[index];
            return Dismissible(
              key: Key(item.id),
              onDismissed: (_) {
                controller.deleteItem(item.id);
              },
              child: CardItem(
                onTapCheck: () {
                  controller.checkItem(item.id);
                },
                item: controller.items[index],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,

        child: const Icon(Icons.add),
      ),
    );
  }
}
