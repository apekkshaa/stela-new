import 'dart:html' as html;
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

    // Encode to bytes
    final excelBytes = excel.encode();
    if (excelBytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    // Create blob and download
    final blob = html.Blob([excelBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement;
    anchor.href = url;
    anchor.download = filename;
    anchor.style.display = 'none';
    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);

    return 'downloaded:$filename';
  } catch (e) {
    throw Exception('Failed to create Excel file: $e');
  }
}
