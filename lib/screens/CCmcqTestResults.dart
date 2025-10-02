
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
      home: CCMCQTablePage(),
    );
  }
}

class CCMCQTablePage extends StatefulWidget {
  @override
  _CCMCQTablePageState createState() => _CCMCQTablePageState();
}

class _CCMCQTablePageState extends State<CCMCQTablePage> {
  final databaseReference = FirebaseDatabase.instance.ref();

  List<String> secondColumnData = [];
  List<String> thirdColumnData = [];
  


  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
  databaseReference.child('CC').once().then((DatabaseEvent event) {
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        List<String> data1 = [];
List<String> data3 = [];


values.forEach((key, value) {
  if (value is Map<String, dynamic>) {
    // Add the name of the child node to data list (second column)
    data1.add(key.toString());
        String totalMarks = value['3_Marks obtained'].toString();
        data3.add(totalMarks);
      
    
  }
});

            // Add all the data inside the child node to data list (third column)
            

        setState(() {
          secondColumnData = data1;
          thirdColumnData = data3;
         




        });
      }
    }
  });
}






  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('COA MCQ ASSESSMENT RESULTS'),
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
                      'Total Marks out of 11',
                      textAlign: TextAlign.center,
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





/*import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseTableScreen extends StatefulWidget {
  @override
  _FirebaseTableScreenState createState() => _FirebaseTableScreenState();
}

class _FirebaseTableScreenState extends State<FirebaseTableScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  List<Map<dynamic, dynamic>> _tableData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _database.child('AIPT coding-TEST').onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?; // Explicit casting
      if (values != null) {
        setState(() {
          _tableData.clear(); // Clear existing data
          values.forEach((enoKey, enoValue) {
            Map<dynamic, dynamic> rowData = {'eno': enoKey};
            enoValue.forEach((expKey, expValue) {
              // Assuming each 'exp' has only one attribute 'total marks'
              rowData[expKey] = expValue['total marks'] ?? '';
            });
            _tableData.add(rowData);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Table'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: _tableData.isNotEmpty
              ? _tableData.first.keys.map<DataColumn>((key) {
                  if (key != 'eno') {
                    // Assuming 'eno' is not a column in DataTable
                    return DataColumn(label: Text(key.toString()));
                  } else {
                    return DataColumn(label: Text('eno'));
                  }
                }).toList()
              : [],
          rows: _tableData.map((data) {
            return DataRow(cells: data.keys.map((key) {
              return DataCell(Text(data[key].toString()));
            }).toList());
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FirebaseTableScreen(),
  ));
}*/
