//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stela_app/constants/userDetails.dart';
import 'dart:async';
import 'package:stela_app/screens/ReportGenerationPandas.dart';

import '../constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PandasAssessmentPage());
}

class PandasAssessmentPage extends StatefulWidget {
  @override
  _PandasAssessmentPageState createState() => _PandasAssessmentPageState();
}

class _PandasAssessmentPageState extends State<PandasAssessmentPage> {
  List<String> selectedOptions = ["", "", "", "", "", "", "", "", "", "",""];
  bool resultButtonClicked = false; 
  final databaseReference = FirebaseDatabase.instance.ref(); 
    late int marks;
  bool alreadySubmitted = false;
late DateTime pageVisitTime;
late DateTime pageVisitTimeSubmit;
late String userContent = '';
late String expectedOutput = _controller.text;
final TextEditingController _controller = TextEditingController(text: '''The manipulated value is: 45''');
 String universityName = '';
 String courseName = '';
 String examTypeName = '';
 String place = '';
 final TextEditingController controller = TextEditingController(text: '''x=5645\n''');
late String section2= controller.text;

 List<String> correctAnswers = [
  // Pandas basics questions
  "DataFrame", // Question 1
  "Series", // Question 2
  "read_csv", // Question 3
  "head", // Question 4
  "index", // Question 5
  "loc", // Question 6
  "groupby", // Question 7
  "drop", // Question 8
  "merge", // Question 9
  "pivot_table", // Question 10
];

List<List<String>> questions = [
  // Pandas basics questions
  [
    "Which Pandas data structure is used to store tabular data?",
    "Panel",
    "DataFrame",
    "Series",
    "Table"
  ],
  [
    "Which Pandas data structure is used to store one-dimensional labeled data?",
    "List",
    "Series",
    "Array",
    "DataFrame"
  ],
  [
    "Which function is used to read a CSV file into a Pandas DataFrame?",
    "read_excel",
    "read_csv",
    "read_table",
    "read_json"
  ],
  [
    "Which method is used to view the first few rows of a DataFrame?",
    "start",
    "beginning",
    "head",
    "first"
  ],
  [
    "Which attribute of a DataFrame provides the row labels?",
    "columns",
    "index",
    "rows",
    "labels"
  ],
  [
    "Which method is used to access a group of rows and columns by labels or a boolean array?",
    "iloc",
    "loc",
    "ix",
    "select"
  ],
  [
    "Which method is used to split the data into groups based on some criteria?",
    "split",
    "apply",
    "groupby",
    "aggregate"
  ],
  [
    "Which method is used to remove specified labels from rows or columns?",
    "delete",
    "remove",
    "drop",
    "discard"
  ],
  [
    "Which function is used to combine DataFrame objects by performing a database-style join operation?",
    "concat",
    "combine",
    "join",
    "merge"
  ],
  [
    "Which function is used to create a spreadsheet-style pivot table as a DataFrame?",
    "pivot_table",
    "pivot",
    "crosstab",
    "table"
  ],
];


late Timer _timer;
  bool timerExpired = false;

  int _remainingTime = 600; // 10 minutes in seconds

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
     pageVisitTime = DateTime.now();
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timerExpired = true;
          _timer.cancel(); // Cancel the timer
          _showResultDialog(); // Automatically click the result button
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Assessment'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(timerExpired ? 'Time\'s up!' : 'Time Left: ${_formatTime(_remainingTime)}'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            /*child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: primaryButton,
                ),

   child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Enter Text:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10), // Add some space between text and text field
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20), // Add some space between the text field and "AIM" text
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: primaryButton,
                ),*/

                

 child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: primaryButton,
                ),

                child: SelectableText(
                  'FILL BASIC DETAILS BEFORE SUBMISSION',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PTSerif',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //SizedBox(height: 20), 
              
              // Add space before the WidgetSpan
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'University Name: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 300, // Adjust the width as needed
                        child: TextField(
                          onChanged: (newValue) {
                            // Update the university name here
                            setState(() {
                              universityName = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              

RichText(
                text: TextSpan(
                  children: [
                    
                    TextSpan(
                      text: 'Course Name: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 300, // Adjust the width as needed
                        child: TextField(
                          onChanged: (newValue) {
                            // Update the university name here
                            setState(() {
                              courseName = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              RichText(
                text: TextSpan(
                  children: [
                    
                    TextSpan(
                      text: 'Exam Type(Practice/ Internal/ External): ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 300, // Adjust the width as needed
                        child: TextField(
                          onChanged: (newValue) {
                            // Update the university name here
                            setState(() {
                              examTypeName = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              RichText(
                text: TextSpan(
                  children: [
                    
                    TextSpan(
                      text: 'Place',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 300, // Adjust the width as needed
                        child: TextField(
                          onChanged: (newValue) {
                            // Update the university name here
                            setState(() {
                              place = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

                SizedBox(height: 20), // Add some space between the "University Name" and "AIM" sections
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: primaryButton,
                ),

                




                child: SelectableText(
                  'PRACTICE QUIZ',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PTSerif',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),



          Column(
            children: <Widget>[
              SizedBox(height: 20),
              for (int i = 0; i < questions.length; i++) _buildQuestionWidget(i + 1, questions[i]),
              SizedBox(height: 20),
              ElevatedButton(
                 onPressed: () {
              _showResultDialog();
                  pageVisitTimeSubmit = DateTime.now();
                  },
                child: Text('Result'),
              ),
              SizedBox(height: 20),
            ],
          ),


 Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                //border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Generate report',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => PdfPagePandas()),
                                                                            );
                                                                          },
                                                                        ),
],
                                                                    ),
                                                                  ),


            ],
      ),

    ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int questionNumber, List<String> question) {
    
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Question $questionNumber: ${question[0]}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (int i = 1; i < question.length; i++)
            RadioListTile(
              title: Text(question[i]),
              value: question[i],
              groupValue: selectedOptions[questionNumber - 1],
              onChanged: (value) {
                setState(() {
                  selectedOptions[questionNumber - 1] = value.toString();
                });
              },
            ),
        ],
      ),
    );
  }

  void _showResultDialog() async {
    int correctCount = 0;
  int incorrectCount = 0;
  int unattemptedCount = 0;
  List<String> result = [];

  for (int i = 0; i < correctAnswers.length; i++) {
    if (selectedOptions[i] == correctAnswers[i]) {
      correctCount++;
      result.add('Correct');
    } else if (selectedOptions[i].isEmpty) {
      unattemptedCount++;
      result.add('Unattempted');
    } else {
      incorrectCount++;
      result.add('Incorrect');
    }
  }

  // Check if the name exists in the database
  DataSnapshot snapshot = await databaseReference.child('Pandas').child(enrollmentNo).get();
 
        Duration difference = pageVisitTimeSubmit.difference(pageVisitTime);

int differenceInMinutes = difference.inMinutes;
int differenceInSeconds = difference.inSeconds%60;
  // If the name does not exist, show the result dialog and add the name with marks
  //if (!snapshot.exists) {
    await databaseReference.child('Pandas').child(enrollmentNo).set({
                  '1_Name': name,
                  '2_Total Marks': questions.length,
                  '3_Marks obtained': correctCount,
                  '4_Correct': correctCount,
                  '5_Incorrect': incorrectCount,
                  '6_Unattempted': unattemptedCount,
                   '7_Start time': pageVisitTime.toString(),
                      '8_End time': pageVisitTimeSubmit.toString(),
                      '11_Duration': differenceInMinutes.toString() + " minutes " + differenceInSeconds.toString() + " seconds",
                      '12_University Name': universityName,
                      '13_Course Name': courseName,
                      '14_Exam Type': examTypeName,
                      '15_Place': place,
                });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'RESULT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marks Obtained: $correctCount out of ${correctAnswers.length}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              ...List.generate(
                correctAnswers.length,
                (index) {
                  if (result[index] == 'Correct') {
                    return Text(
                      'Question ${index + 1}: ${result[index]}',
                      style: TextStyle(color: Colors.green),
                    );
                  } else if (result[index] == 'Unattempted') {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Question ${index + 1}: Unattempted, ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Correct Answer: ${correctAnswers[index]}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Question ${index + 1}: Incorrect, ',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: 'Correct Answer: ${correctAnswers[index]}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
            
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Add the name with marks to the database
                await databaseReference.child('Pandas').child(enrollmentNo).set({
                  '1_Name': name,
                  '2_Total Marks': questions.length,
                  '3_Marks obtained': correctCount,
                  '4_Correct': correctCount,
                  '5_Incorrect': incorrectCount,
                  '6_Unattempted': unattemptedCount,
                   '7_Start time': pageVisitTime.toString(),
                      '8_End time': pageVisitTimeSubmit.toString(),
                      '11_Duration': differenceInMinutes.toString() + " minutes " + differenceInSeconds.toString() + " seconds",
                      '12_University Name': universityName,
                      '13_Course Name': courseName,
                      '14_Exam Type': examTypeName,
                      '15_Place': place,

                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  /*} else {
    // If the name already exists, show a message indicating that the assessment has already been submitted
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ASSESSMENT ALREADY SUBMITTED',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your assessment has already been submitted. You cannot submit it again.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }*/
    // Your result dialog implementation
  }

  String _formatTime(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String remainingSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$remainingSeconds";
}

}

  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Assessment'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              for (int i = 0; i < questions.length; i++)
                _buildQuestionWidget(i + 1, questions[i]),
              SizedBox(height: 20),
              ElevatedButton(
                //onPressed: resultButtonClicked ? null : _showResultDialog,
                onPressed: _showResultDialog,
                child: Text('Result'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int questionNumber, List<String> question) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Question $questionNumber: ${question[0]}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (int i = 1; i < question.length; i++)
            RadioListTile(
              title: Text(question[i]),
              value: question[i],
              groupValue: selectedOptions[questionNumber - 1],
              onChanged: (value) {
                setState(() {
                  selectedOptions[questionNumber - 1] = value.toString(); 
                });
              },
            ),
        ],
      ),
    );
  }

  void _showResultDialog() async {
  int correctCount = 0;
  int incorrectCount = 0;
  int unattemptedCount = 0;
  List<String> result = [];

  for (int i = 0; i < correctAnswers.length; i++) {
    if (selectedOptions[i] == correctAnswers[i]) {
      correctCount++;
      result.add('Correct');
    } else if (selectedOptions[i].isEmpty) {
      unattemptedCount++;
      result.add('Unattempted');
    } else {
      incorrectCount++;
      result.add('Incorrect');
    }
  }

  // Check if the name exists in the database
  DataSnapshot snapshot = await databaseReference.child('COA').child(enrollmentNo).get();

  // If the name does not exist, show the result dialog and add the name with marks
  if (!snapshot.exists) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'RESULT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marks Obtained: $correctCount out of ${correctAnswers.length}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              ...List.generate(
                correctAnswers.length,
                (index) {
                  if (result[index] == 'Correct') {
                    return Text(
                      'Question ${index + 1}: ${result[index]}',
                      style: TextStyle(color: Colors.green),
                    );
                  } else if (result[index] == 'Unattempted') {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Question ${index + 1}: Unattempted, ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Correct Answer: ${correctAnswers[index]}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Question ${index + 1}: Incorrect, ',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: 'Correct Answer: ${correctAnswers[index]}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Add the name with marks to the database
                await databaseReference.child('COA').child(enrollmentNo).set({
                  '1_Name': name,
                  '2_Total Marks': questions.length,
                  '3_Marks obtained': correctCount,
                  '4_Correct': correctCount,
                  '5_Incorrect': incorrectCount,
                  '6_Unattempted': unattemptedCount,

                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    // If the name already exists, show a message indicating that the assessment has already been submitted
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ASSESSMENT ALREADY SUBMITTED',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your assessment has already been submitted. You cannot submit it again.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


}*/


/*Map<String, dynamic>? data, document;
var userDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AssessmentPage());
}

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<String> selectedOptions = ["", "", "", "", ""];
  bool resultButtonClicked = false; // To track if result button is clicked
  final databaseReference = FirebaseDatabase.instance.reference(); // Firebase database reference

  // Define the correct answers for each question
  List<String> correctAnswers = ["Paris", "William Shakespeare", "H2O", "Mars", "Leonardo da Vinci"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Assessment'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              _buildQuestionWidget(1),
              _buildQuestionWidget(2),
              _buildQuestionWidget(3),
              _buildQuestionWidget(4),
              _buildQuestionWidget(5),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resultButtonClicked ? null : _showResultDialog, // Disable button after first click
                child: Text('Result'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int questionNumber) {
    late String question;
    late List<String> options;

    // Define questions and options based on questionNumber
    switch (questionNumber) {
      case 1:
        question = 'What is the capital of France?';
        options = ['Paris', 'Berlin', 'London', 'Rome'];
        break;
      case 2:
        question = 'Who wrote "Romeo and Juliet"?';
        options = ['William Shakespeare', 'Jane Austen', 'Charles Dickens', 'Mark Twain'];
        break;
      case 3:
        question = 'What is the chemical symbol for water?';
        options = ['H2O', 'CO2', 'NaCl', 'O2'];
        break;
      case 4:
        question = 'Which planet is known as the Red Planet?';
        options = ['Mars', 'Venus', 'Mercury', 'Jupiter'];
        break;
      case 5:
        question = 'Who painted the Mona Lisa?';
        options = ['Leonardo da Vinci', 'Pablo Picasso', 'Vincent van Gogh', 'Michelangelo'];
        break;
      default:
        question = 'Question';
        options = ['Option A', 'Option B', 'Option C', 'Option D'];
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Question $questionNumber: $question',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (var option in options)
            RadioListTile(
              title: Text(option),
              value: option,
              groupValue: selectedOptions[questionNumber - 1],
              onChanged: (value) {
                setState(() {
                  selectedOptions[questionNumber - 1] = value.toString(); // Ensure value is converted to String
                });
              },
            ),
        ],
      ),
    );
  }

  void _showResultDialog() async {
    int correctCount = 0;
    List<String> result = [];
    

    for (int i = 0; i < correctAnswers.length; i++) {
  if (selectedOptions[i] == correctAnswers[i]) {
    correctCount++;
    result.add('Correct');
  } else if (selectedOptions[i] == null || selectedOptions[i].isEmpty) {
    result.add('Unattempted, Correct Answer: ${correctAnswers[i]}');
  } else {
    result.add('Incorrect, Correct Answer: ${correctAnswers[i]}');
  }
}



    // Upload marks to Firebase
    databaseReference.child(name).get().then((DataSnapshot snapshot) {
  if (!snapshot.exists) {
    // Name does not exist in the database, so we add it
    return databaseReference.child(name).set({
      'marks': correctCount,
    });
  }
}).catchError((error) {
  print('Error fetching data: $error');
});





    setState(() {
      resultButtonClicked = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'RESULT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
  correctAnswers.length,
  (index) {
    if (result[index] == 'Correct') {
      return Text(
        'Question ${index + 1}: ${result[index]}',
        style: TextStyle(color: Colors.green),
      );
    } else if (result[index] == 'Unattempted') {
      return Text(
        'Question ${index + 1}: Unattempted, Correct Answer: ${correctAnswers[index]}',
        style: TextStyle(color: Colors.yellow),
      );
    } else {
      return Text(
        'Question ${index + 1}: Incorrect, Correct Answer: ${correctAnswers[index]}',
        style: TextStyle(color: Colors.red),
      );
    }
  }
),

          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
*/

/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/PandasexperimentList.dart'
    as PandasexperimentList;
import 'package:stela_app/screens/NumpyexperimentList copy.dart';
import 'package:stela_app/screens/MatplotlibexperimentList copy.dart';
import 'package:stela_app/screens/PandasexperimentList copy.dart';
import 'package:stela_app/screens/SeabornexperimentList copy.dart';
import 'package:stela_app/screens/TensorflowexperimentList copy.dart';
import 'package:stela_app/screens/SklearnexperimentList copy.dart';
import 'package:stela_app/screens/KerasexperimentList copy.dart';
import 'package:stela_app/screens/PytorchexperimentList copy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stela_app/constants/userDetails.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(AssessmentPage());
}

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<String> selectedOptions = ["", "", "", "", ""];

  // Define the correct answers for each question
  List<String> correctAnswers = ["Paris", "Option B", "Option C", "Option D", "Option A"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Assessment'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              _buildQuestionWidget(1),
              _buildQuestionWidget(2),
              _buildQuestionWidget(3),
              _buildQuestionWidget(4),
              _buildQuestionWidget(5),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showResultDialog,
                child: Text('Result'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int questionNumber) {
  late String question;
  late List<String> options;

  // Define questions and options based on questionNumber
  switch (questionNumber) {
    case 1:
      question = 'What is the capital of France?';
      options = ['Paris', 'Berlin', 'London', 'Rome'];
      break;
    case 2:
      question = 'Who wrote "Romeo and Juliet"?';
      options = ['William Shakespeare', 'Jane Austen', 'Charles Dickens', 'Mark Twain'];
      break;
    case 3:
      question = 'What is the chemical symbol for water?';
      options = ['H2O', 'CO2', 'NaCl', 'O2'];
      break;
    case 4:
      question = 'Which planet is known as the Red Planet?';
      options = ['Mars', 'Venus', 'Mercury', 'Jupiter'];
      break;
    case 5:
      question = 'Who painted the Mona Lisa?';
      options = ['Leonardo da Vinci', 'Pablo Picasso', 'Vincent van Gogh', 'Michelangelo'];
      break;
    default:
      question = 'Question';
      options = ['Option A', 'Option B', 'Option C', 'Option D'];
  }

  return Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Question $questionNumber: $question',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        for (var option in options)
          RadioListTile(
            title: Text(option),
            value: option,
            groupValue: selectedOptions[questionNumber - 1],
            onChanged: (value) {
              setState(() {
                selectedOptions[questionNumber - 1] = value.toString(); // Ensure value is converted to String
              });
            },
          ),
      ],
    ),
  );
}



  void _showResultDialog() {
    int correctCount = 0;
    for (int i = 0; i < correctAnswers.length; i++) {
      if (selectedOptions[i] == correctAnswers[i]) {
        correctCount++;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
          'RESULT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      
          content: Text('Marks: $correctCount/ ${correctAnswers.length}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}*/


