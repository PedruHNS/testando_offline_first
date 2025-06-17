import 'dart:convert';

class Item {
  final String id;
  final String name;
  final double value;
  final int qtd;
  final bool isDone;
  final bool isSynced;
  Item({
    required this.id,
    required this.name,
    required this.value,
    required this.qtd,
    required this.isDone,
    required this.isSynced,
  });

  Item copyWith({
    String? id,
    String? name,
    double? value,
    int? qtd,
    bool? isDone,
    bool? isSynced,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      qtd: qtd ?? this.qtd,
      isDone: isDone ?? this.isDone,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'qtd': qtd,
      'isDone': isDone ? 1 : 0,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      qtd: map['qtd']?.toInt() ?? 0,
      isDone: map['isDone'] == 1 ? true : false,
      isSynced: map['isSynced'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
