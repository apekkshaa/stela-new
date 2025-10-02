import 'package:stela_app/screens/globals.dart';

List<String> expNo = [
  "1",
  "2",
  "3",
  "4",
  //"4(b)",
  "5",
  "6",
  "7",
  "8",
  //"8(b)",
  "9",
  "10",
  /*"11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20"*/
];

var practiceQues = ["Q1. ", "Q2.  ", "Q3.  ", "Q4.  ", "Q5. "];

var practiceAns = ["Three", "True", "2^n - 1", "Brahma", "jnkjals"];

var experimentCollection, experimentDoc, experimentData;
String aim = "",
    procedure = "",
    algorithm = "",
    program = "",
    result = "",
    link = "",
    material="",
    otherlinks="";
void getBasicsExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = BasicsExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
    link = data["Link"];
    material = data["Material"];
    otherlinks = data["Resources"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getNumpyExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = NumpyExperimentCollection.doc(docID).get().then((data) {
    aim = data["AIM"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["PROGRAM"];
     link = data["Link"];
     
      material = data["Material"];
       otherlinks = data["Resources"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getMatplotlibExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = MatplotlibExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
     link = data["Link"];
      material = data["Material"];
       otherlinks = data["Resources"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getPandasExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = PandasExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
     link = data["Link"];
      material = data["Material"];
       otherlinks = data["Resources"];
    result = data["RESULT"];
   
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getSeabornExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = SeabornExperimentCollection.doc(docID).get().then((data) {
    aim = data["AIM"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["PROGRAM"];
     link = data["Link"];
      otherlinks = data["Resources"];
      material = data["Material"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getTensorflowExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = TensorflowExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
     link = data["Link"];
      otherlinks = data["Resources"];
      material = data["Material"];
    result = data["RESULT"];
  
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getSklearnExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = SklearnExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
     link = data["Link"];
      otherlinks = data["Resources"];
      material = data["Material"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getKerasExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = KerasExperimentCollection.doc(docID).get().then((data) {
    aim = data["AIM"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["PROGRAM"];
     link = data["Link"];
      otherlinks = data["Resources"];
      material = data["Material"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}

void getPytorchExperiment(var index) {
  var docID = "Experiment " + expNo[index];
  experimentDoc = PytorchExperimentCollection.doc(docID).get().then((data) {
    aim = data["Aim"];
    //procedure = data["PROCEDURE"];
    //algorithm = data["ALGORITHM"];
    program = data["Program"];
     link = data["Link"];
      otherlinks = data["Resources"];
      material = data["Material"];
    result = data["RESULT"];
    practiceQues[0] = data["Practice1"];
    practiceAns[0] = data["PracticeAns1"];
    practiceQues[1] = data["Practice2"];
    practiceAns[1] = data["PracticeAns2"];
    practiceQues[2] = data["Practice3"];
    practiceAns[2] = data["PracticeAns3"];
    practiceQues[3] = data["Practice4"];
    practiceAns[3] = data["PracticeAns4"];
    practiceQues[4] = data["Practice5"];
    practiceAns[4] = data["PracticeAns5"];
    // practiceQues[5] = data?["Practice6"];
    // practiceAns[5] = data?["PracticeAns6"];
    // practiceQues[6] = data?["Practice7"];
    // practiceAns[6] = data?["PracticeAns7"];
    // practiceQues[7] = data?["Practice8"];
    // practiceAns[7] = data?["PracticeAns8"];
    // practiceQues[8] = data?["Practice9"];
    // practiceAns[8] = data?["PracticeAns9"];
    // practiceQues[9] = data?["Practice10"];
    // practiceAns[9] = data?["PracticeAns10"];
  });
}
