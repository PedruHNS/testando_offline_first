import 'package:flutter/material.dart';

import 'package:teste_offline_first/UI/page/shopping_list/shopping_list_controller.dart';

class AdicionarItemModal extends StatelessWidget {
  final ShoppingListController controller;

  const AdicionarItemModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        child: Column(
          spacing: 12,
          children: [
            Text(
              'Adicionar Novo Item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),

            TextField(
              controller: controller.nameEC,
              decoration: InputDecoration(
                hintText: 'Nome',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),

            TextField(
              controller: controller.valueEC,
              decoration: InputDecoration(
                hintText: 'Valor',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              enableSuggestions: false,
            ),

            TextField(
              controller: controller.qtdEC,
              decoration: InputDecoration(
                hintText: 'Quantidade',
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              enableSuggestions: false,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.addItem();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check_circle_outline),
                label: Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
