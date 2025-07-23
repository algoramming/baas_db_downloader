import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../textfield_tags/controller.dart';

typedef PocketbaseNotifier = NotifierProvider<PocketbaseProvider, void>;

final pocketbaseProvider = PocketbaseNotifier(PocketbaseProvider.new);

class PocketbaseProvider extends Notifier<void> {
  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  final tableController = TextEditingController();
  late final StringTagController<String> columnsController;
  final List<String> columns = [];

  List<Map<String, dynamic>> jsonData = [];

  @override
  void build() {
    columnsController = StringTagController<String>();
  }

  void addColumn(String column) {
    if (column.isNotEmpty && !columns.contains(column)) {
      columns.add(column);
      columnsController.addTag(column);
    }
    ref.notifyListeners();
  }

  void removeColumn(String column) {
    columns.remove(column);
    columnsController.removeTag(column);
    ref.notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    try {
      EasyLoading.show();
      final pb = PocketBase(urlController.text);
      final records = await pb
          .collection(tableController.text)
          .getFullList(fields: columns.isNotEmpty ? columns.join(',') : null);
      log('Records fetched total: ${records.length} items');
      jsonData = records.map((e) => e.toJson()).toList();
      log('JSON Data: $jsonData');
      ref.notifyListeners();
    } catch (e) {
      log('Error fetching data: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      return;
    } finally {
      EasyLoading.dismiss();
    }
  }

}
