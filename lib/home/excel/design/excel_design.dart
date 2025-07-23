import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import '../file_handle.dart';

class ExcelDesign {
  final List<Map<String, dynamic>> data;
  final bool isWeb;

  ExcelDesign({required this.data, required this.isWeb});

  List<String> get tableHeaders {
    if (data.isEmpty) return [];

    // Get all unique keys from all data entries
    Set<String> allKeys = {};
    for (var item in data) {
      allKeys.addAll(item.keys);
    }

    return ['#', ...allKeys.toList()..sort()];
  }

  List<List<String>> get tableItems {
    if (data.isEmpty) return [];

    return List.generate(data.length, (idx) {
      List<String> row = ['${idx + 1}'];

      // Get sorted keys (excluding the serial number)
      List<String> sortedKeys = tableHeaders.sublist(1);

      for (String key in sortedKeys) {
        var value = data[idx][key];
        String cellValue;

        if (value == null) {
          cellValue = '-';
        } else if (value is Map || value is List) {
          cellValue = value.toString();
        } else if (value is DateTime) {
          cellValue = value.toIso8601String();
        } else if (value is double) {
          cellValue = value.toStringAsFixed(2);
        } else {
          cellValue = value.toString();
        }

        row.add(cellValue);
      }

      return row;
    });
  }

  Future<Uint8List> generate() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel[excel.getDefaultSheet() ?? 'Sheet1'];

    if (data.isEmpty) {
      // Create empty file if no data
      List<int>? fileBytes = excel.encode();
      if (fileBytes != null) {
        return await ExcelFileHandle.saveDocument(
          name: 'empty-data-${DateTime.now().millisecondsSinceEpoch}',
          bytes: Uint8List.fromList(fileBytes),
          isWeb: isWeb,
        );
      }
      return Uint8List.fromList([]);
    }

    // Determine the total number of columns for proper merging
    int totalColumns = tableHeaders.length;
    const double minColumnWidth = 12.0; // Minimum width per column
    const double paddingWidth = 5.0; // Extra padding for spacing

    // Define styles
    CellStyle titleStyle = CellStyle(
      bold: true,
      fontSize: 18,
      horizontalAlign: HorizontalAlign.Center,
    );

    CellStyle subtitleStyle = CellStyle(fontSize: 15, horizontalAlign: HorizontalAlign.Center);

    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 13,
      horizontalAlign: HorizontalAlign.Center,
    );

    CellStyle dataStyle = CellStyle(fontSize: 12, horizontalAlign: HorizontalAlign.Center);

    // Title row (Merged & Styled)
    var titleCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    titleCell.value = TextCellValue('BaaS Database Export');
    titleCell.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      CellIndex.indexByColumnRow(columnIndex: totalColumns - 1, rowIndex: 0),
    );

    // Subtitle row (Merged & Styled)
    var subtitleCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
    subtitleCell.value = TextCellValue(
      'Generated on ${DateTime.now().toLocal().toString().split('.')[0]}',
    );
    subtitleCell.cellStyle = subtitleStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
      CellIndex.indexByColumnRow(columnIndex: totalColumns - 1, rowIndex: 1),
    );

    // Data count row (Merged & Styled)
    var countCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2));
    countCell.value = TextCellValue('Total Records: ${data.length}');
    countCell.cellStyle = subtitleStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
      CellIndex.indexByColumnRow(columnIndex: totalColumns - 1, rowIndex: 2),
    );

    // Empty row for spacing
    for (int i = 0; i < totalColumns; i++) {
      var emptyCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
      emptyCell.value = TextCellValue('');
      emptyCell.cellStyle = subtitleStyle;
    }

    // Header row
    for (int col = 0; col < tableHeaders.length; col++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 4));
      cell.value = TextCellValue(tableHeaders[col]);
      cell.cellStyle = headerStyle;
    }

    // Data rows
    for (int rowIdx = 0; rowIdx < tableItems.length; rowIdx++) {
      for (int colIdx = 0; colIdx < tableItems[rowIdx].length; colIdx++) {
        var dataCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: rowIdx + 5),
        );
        dataCell.value = TextCellValue(tableItems[rowIdx][colIdx]);
        dataCell.cellStyle = dataStyle;
      }
    }

    // Adjust Column Width with Auto-Fit and Padding
    for (int colIdx = 0; colIdx < totalColumns; colIdx++) {
      int maxLength = tableHeaders[colIdx].length; // Start with header length

      // Check max length in data rows
      for (var row in tableItems) {
        if (colIdx < row.length) {
          maxLength = row[colIdx].length > maxLength ? row[colIdx].length : maxLength;
        }
      }

      // Calculate column width (Ensure minimum width + padding)
      double calculatedWidth = (maxLength + paddingWidth).toDouble();
      sheet.setColumnWidth(
        colIdx,
        calculatedWidth < minColumnWidth ? minColumnWidth : calculatedWidth,
      );
    }

    // Save the file
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      return await ExcelFileHandle.saveDocument(
        name: 'baas-export-${DateTime.now().millisecondsSinceEpoch}',
        bytes: Uint8List.fromList(fileBytes),
        isWeb: isWeb,
      );
    }
    return Uint8List.fromList([]);
  }
}
