import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:stela_app/constants/userDetails.dart'; 

import 'MyFileexperiment.dart';
 late Future<void> _fetchDataFuture;

var expNum;
bool linkClicked = false;

class MyFiles extends StatefulWidget {
  @override
  _MyFilesState createState() => _MyFilesState();

}


class _MyFilesState extends State<MyFiles> {
  String? code;
  List<Map<String, String>> codeList = [];

  /*final colChildren = <Widget>[];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 10; i++) {
      colChildren.add(new ListTile());
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryWhite,
        appBar: AppBar(
          title: Text('STELA'),
          backgroundColor: primaryBar,
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: primaryWhite,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text('Python Tutorial',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PTSerif-Bold',
                            fontWeight: FontWeight.bold))),
                Container(
                  child: Column(
                    children: List.generate(
                      expNo.length,
                      (index) {
                        return TextButton(
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: primaryBar,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2.0, color: primaryButton),
                                      ),
                                      child: Text(
                                        'Practice Module',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'PTSerif-Bold',
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )),
                          
                          /*child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                color: primaryButton,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 2.0, color: primaryBar),
                              ),
                              child: Text('Basics' + expNo[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PTSerif',
                                    color: primaryBar,
                                  ),
                                  textAlign: TextAlign.center)),*/
                                  
                          onPressed: () {
                            /* expNum = index;
                            getExperiment(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Modules()),*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BasicsExperimentList()),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),*/

         @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchDataFromDatabase();
  }

       Future<void> fetchDataFromDatabase() async {
         final databaseReference = FirebaseDatabase.instance.ref();
        final DatabaseEvent event = await databaseReference
    .child('My files')
    .child(enrollmentNo)
    .once();

if (event.snapshot.value != null) {
  Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;

  if (values != null && values is Map<String, dynamic>) {
    setState(() {
      int count = 0;
      List<Map<String, String>> codeList = [];

      values.forEach((key, value) {
        if (value is Map<dynamic, dynamic> && value.containsKey('1_Code')) {
          codeList.add({'key': key, 'code': value['1_Code'].toString()});
          count++;
        }
      });

      // Store the codeList in the state
      this.codeList = codeList;
    });
  }
}

       }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryWhite,
        appBar: AppBar(
          title: Text('STELA'),
          backgroundColor: primaryBar,
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: primaryWhite,
              )),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
                // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  //Container(padding: EdgeInsets.all(10), child: Text('STELA', style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'PTSerif-ExtraBold', fontWeight: FontWeight.bold))),
                  Container(
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Text('PRACTICE SECTION',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'PTSerif-Bold',
                                  fontWeight: FontWeight.w900,
                                ))),
                        /*Container(
                          width: 50,
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            /*child: Image(
                              image: NetworkImage(
                                  'https://png.pngitem.com/pimgs/s/77-775088_take-the-free-assessment-findings-icon-png-transparent.png'),
                            ),*/
                          ),
                        ),*/
                        

                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Practice Python Coding: You can practice your code and save them.',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                                 String initialProgram = "";
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => MyFileExperiment(initialProgram: initialProgram),),
                                                                            );
                                                                          },
                                                                     
                                                                        ),
SizedBox(height: 50),





                       Container(
                            padding: EdgeInsets.all(10),
                            child: Text('MY SAVED CODES',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'PTSerif-Bold',
                                  fontWeight: FontWeight.w900,
                                ))),

 /*codeList.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : */
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: codeList.length,
                        itemBuilder: (context, index) {
                          final record = codeList[index];
                          final key = record['key']!;
                          final code = record['code']!;

                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: primaryButton,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 2.0, color: primaryBar),
                                ),
                                child: Text(
                                  "Your saved code you named:  "+ key,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold,
                                    color: primaryBar,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () {
                                 String initialProgram = code;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyFileExperiment(initialProgram: initialProgram),), // Ensure this navigates to the correct screen
                                );
                              },
                            ),
                          );
  },
                      ),       






                                                                  
                            //],
                          //),
                       // ),
                     
                      ]
                   ),
        ),
                ])),
          ),
        ),
         
        bottomNavigationBar: Container(
          color: primaryBar,
          // padding: EdgeInsets.all(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Subjects()),
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: primaryWhite,
                  size: 35,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AnalysisSubjects()),
              //     );
              //   },
              //   icon: Icon(
              //     Icons.saved_search_rounded,
              //     color: primaryWhite,
              //     size: 40,
              //   ),
              // ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                icon: Icon(
                  Icons.account_circle,
                  color: primaryWhite,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
