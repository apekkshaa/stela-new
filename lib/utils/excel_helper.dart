// Conditional export: re-export the platform implementation so callers can call downloadExcelFile()
export 'excel_helper_io.dart' if (dart.library.html) 'excel_helper_web.dart';

// The exported file exposes:
// Future<String> downloadExcelFile(String filename, List<List<dynamic>> rows)
