import 'package:flutter/material.dart'; // import package which contains flutter and dart functions
import 'package:flutter_riverpod/flutter_riverpod.dart'; //[MODULE 4 - RIVERPOD] import packages for riverpod use, such as StateProvider and Consumer
import 'package:encrypt/encrypt.dart' as encrypt; // [MODULE 5]

final textProvider = StateProvider<String>((ref) => ""); //[MODULE 4 - RIVERPOD]                                                                           [Monitor State Changes][Create State Providers]
final encryptedTextProvider = StateProvider<String>((ref) => ""); //[MODULE 4 - RIVERPOD] 

final key = encrypt.Key.fromUtf8('my 32 length key................'); // initialize 32 character key for encryption/decryption
final iv = encrypt.IV.fromLength(16); // set IV to 16 byte
final encrypter = encrypt.Encrypter(encrypt.AES(key)); // call Encryptor from encrypt package to encrypt using key

void main() { // opens main function to run the app
  runApp(const ProviderScope(child: ScaffoldApp())); // runs the app based on the function ScaffoldApp //[MODULE 4 - RIVERPOD]                             [Set Up Riverpod]
} // closes main() function



// ******************************** Module 2 Code *************************************
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



// ******************************** Module 3 Code *************************************
class MyCustomForm extends StatefulWidget { // defines class MyCustomForm which extends StatefulWidget, making the class immutable
  const MyCustomForm({super.key}); // creates instance of MyCustomForm which contains information from parameter super.key

  @override // allows us to override the information from the parent class
  MyCustomFormState createState() { // creates an instance of MyCustomForm which updates the widget based on MyCustomFormState
    return MyCustomFormState(); // return information from MyCustomFormState()
  }
} // close MyCustomForm class


class MyCustomFormState extends State<MyCustomForm> { // **StatefulWidget with Riverpod**
  final _formKey = GlobalKey<FormState>(); // creates a key that identifies the form and allows validation

  @override // allows us to override the information from the parent class build()
  Widget build(BuildContext context) { // opens widget build() with BuildContext in order to build the app with style choices
    
    // returns the values to the providers at the top
    return Consumer( // uses Consumer to access textProvider and encryptedTextProvider
      builder: (context, ref, child) { // passes context and ref for accessing providers //[MODULE 4 - RIVERPOD]
        final text = ref.watch(textProvider); // watches the textProvider for state updates //[MODULE 4 - RIVERPOD]
        final encryptedText = ref.watch(encryptedTextProvider); // watches the encryptedTextProvider for state updates //[MODULE 4 - RIVERPOD]

        // adds padding around the text box
        return Padding( // adds padding to adjust spacing
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // edits horizontal padding to be 16
          child: Form( // creates a form widget to group form-related fields together
            key: _formKey, // assigns the unique form key
            child: Column( // open child section for column settings
              mainAxisSize: MainAxisSize.min, // prevents unnecessary space usage
              children: <Widget>[ // open children section for Widget
                
                // input box actions and style 
                TextFormField( // creates an input field for user text
                  decoration: const InputDecoration( // open decoration section
                    labelText: 'Enter Text', // label above the input field
                    border: OutlineInputBorder(), // adds a visible border
                  ),
                  initialValue: text, // [MODULE 4 - RIVERPOD]                                                                                              [Connect UI to Providers]
                  onChanged: (value) {
                    ref.read(textProvider.notifier).state = value; //[MODULE 4 - RIVERPOD] 
                  },
                  validator: (value) { // validates user input
                    if (value == null || value.isEmpty) { // if value is nothing/empty...
                      return 'Please enter some text'; // display error message
                    } // close if statement section
                    return null; // returns nothing
                  }, // close validator section
                ),
                const SizedBox(height: 10), // space between text field and button
                
                // button style and actions
                ElevatedButton( // creates a button to submit form
                  onPressed: () { // opens onPressed section for when button is pressed
                    if (_formKey.currentState!.validate()) { // verifies if input is valid                                                                 [Validate and Prepare Data]
                      final encrypted = encryptData(text); //[MODULE 5] calls encryptData function to encrypt the input and label it as encrypted
                      ref.read(encryptedTextProvider.notifier).state = encrypted; //[MODULE 4 - RIVERPOD] calls encryptData function to take string input and encrypt
                      ScaffoldMessenger.of(context).showSnackBar( // calls ScaffoldMessenger function to display SnackBar
                        const SnackBar(content: Text('Data Encrypted!')), //[MODULE 4 - RIVERPOD] indicate to user that the data was successfully encrypted
                      );
                    }
                  },
                  child: const Text('Encrypt Data'), //[MODULE 4 - RIVERPOD] indicate to user that the button encrypts the data
                ),

                // display encrypted text
                const SizedBox(height:10), // initialize box which will hold encryption
                Text('Encrypted Text: $encryptedText'), //[MODULE 4 - RIVERPOD] displays the encrypted text to the user (text entered in reverse)
                
                // display decrypted text
                const SizedBox(height:10), // initialize box for text which will hold decryption
                Text( // open text section for text beneath button
                  encryptedText.isNotEmpty // while encryptedTexy is not empty
                      ? 'Decrypted Text: ${decryptData(encryptedText)}' // display the decrypted text if valid input was entered
                      : '', // if there hasn't been an input entered then leave the line blank
                ),
              ],
            ),
          ),
        );
      },
    );
  } // close Widget build() section
} // close MyCustomFormState class



// ******************************** Module 4 Code *************************************
String encryptData(String input) { // open function with takes string input and converts it to base64 encrytion
  return encrypter.encrypt(input, iv: iv).base64; // return base64 encrypted string
}



// ******************************** Module 5 Code *************************************
String decryptData(String encryptedInput) { // take base64 input and converts it to originally given string
  return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedInput), iv: iv); // decrypt using base64 input
}