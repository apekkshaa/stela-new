
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:csv/csv.dart';

import 'dart:html' as html;


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
      home: ATablePage(),
    );
  }
}

class ATablePage extends StatefulWidget {
  @override
  _ATablePageState createState() => _ATablePageState();
}

class _ATablePageState extends State<ATablePage> {
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
    databaseReference.child('AIPT REAL coding-TEST').once().then((DatabaseEvent event) {
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

          /*values.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              // Add the name of the child node to data list (second column)
              data1.add(key.toString());
              value.forEach((experimentKey, experimentValue) {
                
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
              }
              );
            }
          }*/
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
    'Experiment 3',
    'Experiment 4',
    'Experiment 5',
    'Experiment 6',
    'Experiment 7',
    'Experiment 8',
    'Experiment 9',
    'Experiment 10',
    // Add more headers as needed for other columns
  ]);

  // Add data rows
  for (int i = 0; i < secondColumnData.length; i++) {
    rows.add([
      (i + 1).toString(),
      secondColumnData[i],
      thirdColumnData.elementAt(i),
      fourthColumnData.elementAt(i),
      fiveColumnData.elementAt(i),
      sixColumnData.elementAt(i),
      sevenColumnData.elementAt(i),
      eightColumnData.elementAt(i),
      nineColumnData.elementAt(i),
      tenColumnData.elementAt(i),
      elevenColumnData.elementAt(i),
      twelthColumnData.elementAt(i),
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
    ..setAttribute("download", "AIPT_Coding_Assessment_Results.csv")
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
                      (index <= secondColumnData.length)
                          ? secondColumnData[index - 1]
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

             /*   if (index == 0)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Experiment 3',
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
                      (index <= fiveColumnData.length)
                          ? fiveColumnData[index - 1]
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
                      'Experiment 4',
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
                      (index <= sixColumnData.length)
                          ? sixColumnData[index - 1]
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
                      'Experiment 5',
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
                      (index <= sevenColumnData.length)
                          ? sevenColumnData[index - 1]
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
                      'Experiment 6',
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
                      (index <= eightColumnData.length)
                          ? eightColumnData[index - 1]
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
                      'Experiment 7',
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
                      (index <= nineColumnData.length)
                          ? nineColumnData[index - 1]
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
                      'Experiment 8',
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
                      (index <= tenColumnData.length)
                          ? tenColumnData[index - 1]
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
                      'Experiment 9',
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
                      (index <= elevenColumnData.length)
                          ? elevenColumnData[index - 1]
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
                      'Experiment 10',
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
                      (index <= twelthColumnData.length)
                          ? twelthColumnData[index - 1]
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/

 /*if (index == 0)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Experiment 11',
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
                      (index <= eightColumnData.length)
                          ? eightColumnData[index - 1]
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
                      'Experiment 12',
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
                      (index <= eightColumnData.length)
                          ? eightColumnData[index - 1]
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/

                /*(index == 0)
  ? TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Total Marks',
          textAlign: TextAlign.center,
        ),
      ),
    )
  : TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          // Calculate the sum of the last 10 columns and handle null values
          (() {
            int sum = 0;
            for (int i = 0; i < 10; i++) {
              int dataIndex = index - 1 + i * thirdColumnData.length;
              if (dataIndex < thirdColumnData.length) {
                int value1 = int.tryParse(thirdColumnData[dataIndex]) ?? 0;
                int value2 = int.tryParse(fourthColumnData[dataIndex]) ?? 0;
                int value3 = int.tryParse(fiveColumnData[dataIndex]) ?? 0;
                int value4 = int.tryParse(sixColumnData[dataIndex]) ?? 0;
                int value5 = int.tryParse(sevenColumnData[dataIndex]) ?? 0;
                int value6 = int.tryParse(eightColumnData[dataIndex]) ?? 0;
                int value7 = int.tryParse(nineColumnData[dataIndex]) ?? 0;
                int value8 = int.tryParse(tenColumnData[dataIndex]) ?? 0;
                int value9 = int.tryParse(elevenColumnData[dataIndex]) ?? 0;
                int value10 = int.tryParse(twelthColumnData[dataIndex]) ?? 0;
                sum = value1+value2+value3+value4+value5+value6+value7+value8+value9+value10;
              }
            }
            return sum.toString();
          })(),
          textAlign: TextAlign.center,
        ),
      ),
    )

              */


              /*// Placeholders for remaining columns with headings
              for (int i = 2; i < 12; i++)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Heading for Column $i',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/
            ],
          ),
        ),
      ),
    ),
  );
}

}

/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
      home: TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<String> secondColumnData = [];
  List<String> thirdColumnData = [];
  List<String> fourthColumnData=[];
  List<String> fiveColumnData=[];
  List<String> sixColumnData =[];
          List<String> sevenColumnData =[];
          List<String> eightColumnData  =[];
          List<String> nineColumnData =[];
          List<String> tenColumnData =[];
          List<String> elevenColumnData =[];
          List<String> twelthColumnData =[];


  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
  databaseReference.child('AIPT coding-TEST').once().then((DatabaseEvent event) {
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

values.forEach((key, value) {
  if (value is Map<String, dynamic>) {
    // Add the name of the child node to data list (second column)
    data1.add(key.toString());
    value.forEach((experimentKey, experimentValue) {
      if (experimentValue is Map<String, dynamic> ) {
        String totalMarks = experimentValue['1_Total marks'].toString();
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
    });
  }
});

            // Add all the data inside the child node to data list (third column)
            

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
          elevenColumnData=data11;
          twelthColumnData=data12;




        });
      }
    }
  });
}






  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('CODING ASSESSMENT RESULTS'),
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
                      (index <= secondColumnData.length)
                          ? secondColumnData[index - 1]
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

                if (index == 0)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Experiment 3',
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
                      (index <= fiveColumnData.length)
                          ? fiveColumnData[index - 1]
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
                      'Experiment 4',
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
                      (index <= sixColumnData.length)
                          ? sixColumnData[index - 1]
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
                      'Experiment 5',
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
                      (index <= sevenColumnData.length)
                          ? sevenColumnData[index - 1]
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
                      'Experiment 6',
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
                      (index <= eightColumnData.length)
                          ? eightColumnData[index - 1]
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
                      'Experiment 7',
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
                      (index <= nineColumnData.length)
                          ? nineColumnData[index - 1]
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
                      'Experiment 8',
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
                      (index <= tenColumnData.length)
                          ? tenColumnData[index - 1]
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
                      'Experiment 9',
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
                      (index <= elevenColumnData.length)
                          ? elevenColumnData[index - 1]
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
                      'Experiment 10',
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
                      (index <= twelthColumnData.length)
                          ? twelthColumnData[index - 1]
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),


                /*(index == 0)
  ? TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Total Marks',
          textAlign: TextAlign.center,
        ),
      ),
    )
  : TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          // Calculate the sum of the last 10 columns and handle null values
          (() {
            int sum = 0;
            for (int i = 0; i < 10; i++) {
              int dataIndex = index - 1 + i * thirdColumnData.length;
              if (dataIndex < thirdColumnData.length) {
                int value1 = int.tryParse(thirdColumnData[dataIndex]) ?? 0;
                int value2 = int.tryParse(fourthColumnData[dataIndex]) ?? 0;
                int value3 = int.tryParse(fiveColumnData[dataIndex]) ?? 0;
                int value4 = int.tryParse(sixColumnData[dataIndex]) ?? 0;
                int value5 = int.tryParse(sevenColumnData[dataIndex]) ?? 0;
                int value6 = int.tryParse(eightColumnData[dataIndex]) ?? 0;
                int value7 = int.tryParse(nineColumnData[dataIndex]) ?? 0;
                int value8 = int.tryParse(tenColumnData[dataIndex]) ?? 0;
                int value9 = int.tryParse(elevenColumnData[dataIndex]) ?? 0;
                int value10 = int.tryParse(twelthColumnData[dataIndex]) ?? 0;
                sum = value1+value2+value3+value4+value5+value6+value7+value8+value9+value10;
              }
            }
            return sum.toString();
          })(),
          textAlign: TextAlign.center,
        ),
      ),
    )

              */


              /*// Placeholders for remaining columns with headings
              for (int i = 2; i < 12; i++)
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Heading for Column $i',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/
            ],
          ),
        ),
      ),
    ),
  );
}

}*/



