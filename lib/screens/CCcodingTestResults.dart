import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:csv/csv.dart';


import 'package:stela_app/src/browser_html_stub.dart' if (dart.library.html) 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Table Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CCTablePage(),
    );
  }
}

class CCTablePage extends StatefulWidget {
  @override
  _CCTablePageState createState() => _CCTablePageState();
}

class _CCTablePageState extends State<CCTablePage> {
  final databaseReference = FirebaseDatabase.instance.ref();

  List<String> secondColumnData = [];
  List<String> thirdColumnData = [];
  List<String> fourthColumnData = [];
  List<String> fiveColumnData = [];
  List<String> sixColumnData = [];
  List<String> sevenColumnData = [];
  List<String> eightColumnData = [];
  List<String> nineColumnData = [];
  List<String> tenColumnData = [];
  List<String> elevenColumnData = [];
  List<String> twelthColumnData = [];

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
    databaseReference.child('CC coding-TEST').once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          List<String> data1 = [];
          List<String> data3 = [];
          List<String> data4 = [];
          List<String> data5 = [];
          List<String> data6 = [];
          List<String> data7 = [];
          List<String> data8 = [];
          List<String> data9 = [];
          List<String> data10 = [];
          List<String> data11 = [];
          List<String> data12 = [];
          List<String> data13 = [];
          String totalMarks;

          values.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              // Add the name of the child node to data list (second column)
              data1.add(key.toString());
              for (int i = 1; i <= 10; i++) {
                String experimentKey = 'Experiment $i';
                if (value.containsKey(experimentKey)) {
                  var experimentValue = value[experimentKey];
                  if (experimentValue is Map<String, dynamic>) {
                    totalMarks = experimentValue['1_Total marks'].toString();
                    switch (experimentKey) {
                      case 'Experiment 1':
                        data3.add(totalMarks);
                        break;
                      case 'Experiment 2':
                        data4.add(totalMarks);
                        break;
                      case 'Experiment 3':
                        data5.add(totalMarks);
                        break;
                      case 'Experiment 4':
                        data6.add(totalMarks);
                        break;
                      case 'Experiment 5':
                        data7.add(totalMarks);
                        break;
                      case 'Experiment 6':
                        data8.add(totalMarks);
                        break;
                      case 'Experiment 7':
                        data9.add(totalMarks);
                        break;
                      case 'Experiment 8':
                        data10.add(totalMarks);
                        break;
                      case 'Experiment 9':
                        data11.add(totalMarks);
                        break;
                      case 'Experiment 10':
                        data12.add(totalMarks);
                        break;
                      default:
                        break;
                    }
                  }
                } else {
                  // If experiment key is not in database, set totalMarks to 0
                  switch (experimentKey) {
                    case 'Experiment 1':
                      data3.add('0');
                      break;
                    case 'Experiment 2':
                      data4.add('0');
                      break;
                    case 'Experiment 3':
                      data5.add('0');
                      break;
                    case 'Experiment 4':
                      data6.add('0');
                      break;
                    case 'Experiment 5':
                      data7.add('0');
                      break;
                    case 'Experiment 6':
                      data8.add('0');
                      break;
                    case 'Experiment 7':
                      data9.add('0');
                      break;
                    case 'Experiment 8':
                      data10.add('0');
                      break;
                    case 'Experiment 9':
                      data11.add('0');
                      break;
                    case 'Experiment 10':
                      data12.add('0');
                      break;
                    default:
                      break;
                  }
                }
              }
            }
          });

          setState(() {
            secondColumnData = data1;
            thirdColumnData = data3;
            fourthColumnData = data4;
            fiveColumnData = data5;
            sixColumnData = data6;
            sevenColumnData = data7;
            eightColumnData = data8;
            nineColumnData = data9;
            tenColumnData = data10;
            elevenColumnData = data11;
            twelthColumnData = data12;
          });
        }
      }
    });
  }

   void _exportToExcel() async {
    List<List<dynamic>> rows = [];

  // Add header row
  rows.add([
    'Serial number',
    'Enrollment Number',
    'Experiment 1',
    'Experiment 2',
    // Add more headers as needed for other columns
  ]);

  // Add data rows
  for (int i = 0; i < secondColumnData.length; i++) {
    rows.add([
      (i + 1).toString(),
      secondColumnData[i],
      thirdColumnData.elementAt(i),
      fourthColumnData.elementAt(i),
      // Add more data columns as needed
    ]);
  }

  String csv = const ListToCsvConverter().convert(rows);


  // Create a blob containing the CSV data
  final List<int> data = utf8.encode(csv);
  final blob = html.Blob([data]);

  // Create a URL for the blob
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create an anchor element
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "CC_Coding_Assessment_Results.csv")
    ..style.display = 'none';

  // Trigger a download
  html.document.body!.children.add(anchor);
  anchor.click();

  // Clean up
  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('CODING ASSESSMENT RESULTS'),
      actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _exportToExcel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          columnWidths: {
            for (int i = 0; i < 13; i++) i: FlexColumnWidth(1.0),
          },
          children: List.generate(
            secondColumnData.length + 1, // Adjusted for headings
            (index) => TableRow(
              children: [
                // Serial number column
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      (index == 0) ? 'Serial number' : '$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                ),
                // Heading for second column
                if (index == 0)
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Enrollment Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  )
                else
                  // Populate the second column with Firebase data
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        (index <= secondColumnData.length) ? secondColumnData[index - 1] : '',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                 if (index == 0)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Experiment 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                    ),
                  ),
                )
              else
                // Populate the second column with Firebase data
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      (index <= thirdColumnData.length)
                          ? thirdColumnData[index - 1]
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                if (index == 0)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Experiment 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                    ),
                  ),
                )
              else
                // Populate the second column with Firebase data
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      (index <= fourthColumnData.length)
                          ? fourthColumnData[index - 1]
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
// Other columns follow the same pattern...
              ],
            ),
          ),
        ),
      ),
    );
  }
}


