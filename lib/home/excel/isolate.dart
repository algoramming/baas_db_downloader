import 'package:flutter/services.dart';

import 'design/excel_design.dart';

class IsolateMessage {
  final List<Map<String, dynamic>> data;
  final RootIsolateToken? token;
  final bool isWeb;

  IsolateMessage({required this.data, this.token, required this.isWeb});
}

Future<Uint8List> generateExcelInIsolate(IsolateMessage message) async {
  try {
    // Initialize the binary messenger for background isolate
    if (!message.isWeb && message.token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(message.token!);
    }
    
    final statement = ExcelDesign(data: message.data, isWeb: message.isWeb);
    return await statement.generate();
  } catch (e) {
    rethrow;
  }
}
