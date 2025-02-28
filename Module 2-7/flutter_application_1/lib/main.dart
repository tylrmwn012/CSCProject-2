import 'package:flutter/material.dart'; // import package which contains flutter and dart functions

void main() { // opens main function to run the app
  runApp(const ScaffoldApp()); // runs the app based on the function ScaffoldApp
} // closes main() function

class ScaffoldApp extends StatelessWidget { // defines class ScaffoldApp which extends StatelessWidget, making the class immutable
  const ScaffoldApp({super.key}); // creates instance of ScaffoldApp which contains the super.key parameter 

  @override // @override changes information from the parent class createState()
  Widget build(BuildContext context) { // open Widget build() section
    return const MaterialApp(home: ScaffoldScreen()); // returns stuff from ScaffoldScreen through function MaterialApp to be displayed on device
  } // close Widget build() section
} // close ScaffoldApp class

class ScaffoldScreen extends StatefulWidget { // defines class ScaffoldScreen which extends StatefulWidget, making the calss immutable
  const ScaffoldScreen({super.key}); // creates instance of ScaffoldScreen which contains information from parameter super.key

  @override // @override changes information from the parent class createState()
  State<ScaffoldScreen> createState() => _ScaffoldState(); // creates an instance of ScaffoldScreen which updates the widget based on _ScaffoldState
} // close ScaffoldScreen class

class _ScaffoldState extends State<ScaffoldScreen> { // defines class _ScaffoldState which extends State<ScaffoldScreen>, associating it with the ScaffoldScreen class
  @override // allows us to override the information from the parent class build()
  Widget build(BuildContext context) { // opens widget build() with BuildContext in order to build the app with style choices
    return Scaffold( // returns information built in the function Scaffold to void main
      appBar: AppBar( // opens section AppBar to be edited
        title: Text('Secure Data Handling'), // displays text in appBar at top of app
        backgroundColor: Colors.blue,),
      body: Center( // opens section Center to edit the center section of the app
        child: Text('Welcome to Secure Data Handling', // displays text in main section of app
        style: TextStyle(fontSize:20, color:Colors.black))
        ),
    );
  } // close Widget build() section
} // close _ScaffoldState class