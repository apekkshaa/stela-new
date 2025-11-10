import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> downloadCsvFile(String filename, String content) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsString(content);
  return file.path;
}
