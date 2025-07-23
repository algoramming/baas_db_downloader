import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import './web.empty.download.dart' if (dart.library.html) './web.download.dart';

class ExcelFileHandle {
  // save excel file function
  static Future<Uint8List> saveDocument({
    required String name,
    required Uint8List bytes,
    required bool isWeb,
  }) async {
    if (isWeb) {
      return await saveDocumentWeb(name: name, bytes: bytes);
    } else {
      return await saveDocumentNonWeb(name: name, bytes: bytes);
    }
  }

  // save excel file function for non web
  static Future<Uint8List> saveDocumentNonWeb({
    required String name,
    required Uint8List bytes,
  }) async {
    try {
      // Try Downloads directory first, fallback to Documents
      Directory? directory = await getApplicationDocumentsDirectory();
      log('Application Documents Directory: ${directory.path}');

      final file = File(join(directory.path, '$name.xlsx'));
      await file.writeAsBytes(bytes);
      log('Saved file to: ${file.path}');

      EasyLoading.showSuccess('File saved to: ${file.path}');
      return bytes;
    } catch (e) {
      rethrow;
    }
  }

  // save excel file function for web
  static Future<Uint8List> saveDocumentWeb({required String name, required Uint8List bytes}) async {
    webDownload(bytes, '$name.xlsx');
    return bytes;
  }
}
