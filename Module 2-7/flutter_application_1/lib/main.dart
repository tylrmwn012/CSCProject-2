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

class ScaffoldScreen extends StatefulWidget { // defines class ScaffoldScreen which extends StatefulWidget, making the class immutable
  const ScaffoldScreen({super.key}); // creates instance of ScaffoldScreen which contains information from parameter super.key

  @override // @override changes information from the parent class createState()
  State<ScaffoldScreen> createState() => _ScaffoldState(); // creates an instance of ScaffoldScreen which updates the widget based on _ScaffoldState
} // close ScaffoldScreen class

class _ScaffoldState extends State<ScaffoldScreen> { // defines class _ScaffoldState which extends State<ScaffoldScreen>, associating it with the ScaffoldScreen class
  @override // allows us to override the information from the parent class build()
  Widget build(BuildContext context) { // opens widget build() with BuildContext in order to build the app with style choices
    return Scaffold( // returns information built in the function Scaffold to void main
      appBar: AppBar( // opens section AppBar to be edited
        title: const Text('Secure Data Handling'), // displays text in appBar at top of app
        backgroundColor: Colors.blue, // changes AppBar background to blue
      ),
      body: Column( // initiales body of app as column
        mainAxisAlignment: MainAxisAlignment.center, // alligns everything to the center of the screen
        children: const [ // define children sections and styles
          Center( // open center section
            child: Text( // enter text information
              'Welcome to Secure Data Handling', // displays text in main section of app
              style: TextStyle(fontSize: 20, color: Colors.black), // sets text size and color for welcome message
            ),
          ),
          SizedBox(height: 20), // set space pace between the welcome text and form
          MyCustomForm(), // displays form box below text
        ],
      ),
    );
  } // close Widget build() section
} // close _ScaffoldState class

class MyCustomForm extends StatefulWidget { // defines class MyCustomForm which extends StatefulWidget, making the class immutable
  const MyCustomForm({super.key}); // creates instance of MyCustomForm which contains information from parameter super.key

  @override // allows us to override the information from the parent class
  MyCustomFormState createState() { // creates an instance of MyCustomForm which updates the widget based on MyCustomFormState
    return MyCustomFormState(); // return information from MyCustomFormState()
  }
} // close MyCustomForm class

class MyCustomFormState extends State<MyCustomForm> { // defines class MyCustomFormState which extends State<MyCustomForm>, associating it with the MyCustomForm class
  final _formKey = GlobalKey<FormState>(); // creates a key that identifies the form and allows validation

  @override // allows us to override the information from the parent class build()
  Widget build(BuildContext context) { // opens widget build() with BuildContext in order to build the app with style choices
    return Padding( // adds padding to adjust spacing
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // edits horizontal padding to be 16
      child: Form( // creates a form widget to group form-related fields together
        key: _formKey, // assigns the unique form key
        child: Column( // open child section for column settings
          mainAxisSize: MainAxisSize.min, // prevents unnecessary space usage
          children: <Widget>[ // open children seciton for Widget
            TextFormField( // creates an input field for user text
              decoration: const InputDecoration( // open decoration section
                labelText: 'Enter Text', // label above the input field
                border: OutlineInputBorder(), // adds a visible border
              ),
              validator: (value) { // validates user input
                if (value == null || value.isEmpty) { // if value is nothing/empty...
                  return 'Please enter some text'; // display error message
                } // close if statement section
                return null; // returns nothing
              }, // close validator section
            ),
            SizedBox(height: 10), // space between text field and button
            ElevatedButton( // creates a button to submit form
              onPressed: () { // opens onPressed section for when button is pressed
                if (_formKey.currentState!.validate()) { // verifies if input is valid
                  ScaffoldMessenger.of(context).showSnackBar( // calls ScaffoldMessenger function to display SnackBar
                    const SnackBar(content: Text('Processing Data')), // displays a message when form is submitted
                  ); 
                }
              },
              child: const Text('Submit'), // sets text inside of button
            ),
          ],
        ),
      ),
    );
  } // close Widget build() section
} // close MyCustomFormState class
