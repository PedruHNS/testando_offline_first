import 'package:flutter/material.dart';
import 'package:teste_offline_first/model/item_model.dart';

class CardItem extends StatelessWidget {
  final VoidCallback onTapCheck;
  final Item item;
  const CardItem({super.key, required this.item, required this.onTapCheck});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: GestureDetector(
          onTap: onTapCheck,
          child: Icon(
            item.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: item.isDone ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Qtd: ${item.qtd}  •  Valor: R\$ ${item.value.toStringAsFixed(2)}',
        ),
        trailing: Icon(
          item.isSynced ? Icons.cloud_done : Icons.cloud_off,
          color: item.isSynced ? Colors.blue : Colors.red,
        ),
      ),
    );
  }
}
