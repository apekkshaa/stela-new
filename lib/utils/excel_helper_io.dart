import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';

Future<String> downloadExcelFile(String filename, List<List<dynamic>> rows) async {
  try {
    // Create a new Excel workbook
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add all rows to the sheet
    for (var row in rows) {
      // Convert each cell to proper CellValue type
      final cellValues = <CellValue?>[];
      for (var cell in row) {
        if (cell == null) {
          cellValues.add(null);
        } else if (cell is int) {
          cellValues.add(IntCellValue(cell));
        } else if (cell is double) {
          cellValues.add(DoubleCellValue(cell));
        } else {
          cellValues.add(TextCellValue(cell.toString()));
        }
      }
      sheet.appendRow(cellValues);
    }

    // Save to temp directory
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(excel.encode()!);
    
    return file.path;
  } catch (e) {
    throw Exception('Failed to create Excel file: $e');
  }
}
