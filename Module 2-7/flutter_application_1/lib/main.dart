import 'package:flutter/material.dart'; // import package which contains flutter and dart functions
import 'package:flutter_riverpod/flutter_riverpod.dart'; //[MODULE 4 - RIVERPOD] import packages for riverpod use, such as StateProvider and Consumer
import 'package:encrypt/encrypt.dart' as encrypt; // [MODULE 5]
import 'package:uuid/uuid.dart'; //[MODULE 6]
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; //[MODULE 6]
import 'package:permission_handler/permission_handler.dart'; //[MODULE 6]

final textProvider = StateProvider<String>((ref) => ""); //[MODULE 4 - RIVERPOD]                                                                          
final encryptedTextProvider = StateProvider<String>((ref) => ""); //[MODULE 4 - RIVERPOD] 
final decryptedTextProvider = StateProvider<String>((ref) => ""); //[MODULE 4 - RIVERPOD]


final key = encrypt.Key.fromUtf8('my 32 length key................'); // initialize 32 character key for encryption/decryption
final iv = encrypt.IV.fromLength(16); // set IV to 16 byte
final encrypter = encrypt.Encrypter(encrypt.AES(key)); // call Encryptor from encrypt package to encrypt using key

final storage = FlutterSecureStorage(); // [MODULE 6] initialize secure storage

void main() { // opens main function to run the app
  runApp(const ProviderScope(child: ScaffoldApp())); // runs the app based on the function ScaffoldApp //[MODULE 4 - RIVERPOD]                           
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

class _ScaffoldState extends State<ScaffoldScreen> {
  Future<String>? decryptedFuture; // store Future to prevent unnecessary re-execution

  @override // allows us to override information from parent class initState()
  void initState() { // call function initState() to be altered
    super.initState(); // calls parent class to initialize information
    decryptedFuture = decryptStoredData(); // set decryptedFuture equal to function decryptedStoredData()
  }

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
    return Consumer( // uses Consumer to access textProvider and Provider
      builder: (context, ref, child) { // passes context and ref for accessing providers //[MODULE 4 - RIVERPOD]
        final text = ref.watch(textProvider); // watches the textProvider for state updates //[MODULE 4 - RIVERPOD]
        final encryptedText = ref.watch(encryptedTextProvider); // watches the encryptedTextProvider for state updates //[MODULE 4 - RIVERPOD]
        final decryptedText = ref.watch(decryptedTextProvider); // Watches decrypted text state


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
                  initialValue: text, // [MODULE 4 - RIVERPOD]                                                                                              
                  onChanged: (value) { // when value is changed (user enters text)...
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
                
                // [ENCRYPT] button style and actions
                ElevatedButton( // creates a button to submit form
                  onPressed: () async { // when the button is pressed (calls async to sync info with other functions like request permission)
                    if (_formKey.currentState!.validate()) { // verifies if input is valid  
                      await storeEncryptedData(ref.read(textProvider)); // store the encrypted data
                      ref.read(encryptedTextProvider.notifier).state = encryptData(ref.read(textProvider)); // encrypts data if necessary
                      ScaffoldMessenger.of(context).showSnackBar( // call snackbar
                        const SnackBar(content: Text('Data Encrypted & Stored')), // print text at bottom of the screen if successful
                      );
                    }
                  },
                  child: const Text('Encrypt Data'), //[MODULE 4 - RIVERPOD] indicate to user that the button encrypts the data
                ),

                // [DECRYPT] button action
                ElevatedButton(
                  onPressed: () async { // when the button is pressed...
                    final decryptedTextValue = await decryptStoredData(); // call function to decrypt the stored data
                    ref.read(decryptedTextProvider.notifier).state = decryptedTextValue; // updates provider to decryptedTextValue
                    ScaffoldMessenger.of(context).showSnackBar( // open snackbar for styling
                      const SnackBar(content: Text('Data Decrypted & Displayed')), // display message at bottom of the screen to tell user decryption processed
                    );
                  },
                  child: const Text('Decrypt Data'), // display text "decrypt data" inside of button
                ),

                const SizedBox(height:10), // initialize box which will hold encryption
                Text('Encrypted Text: $encryptedText'), // display encrypted text to user

                const SizedBox(height: 10), // initialize box which will hold decryption
                Text('Decrypted Data: $decryptedText'), // display decrypted text to user
              ],
            ),
          ),
        );
      },
    );
  }
}



// ******************************** Module 4 Code *************************************
String encryptData(String input) { // function which takes user's input and encrypts
  return encrypter.encrypt(input, iv: iv).base64; // return encryption of user's input with base64
}

Future<void> storeEncryptedData(String text) async {
  final iv = encrypt.IV.fromLength(16); // Generate a new IV per encryption
  final encrypted = encrypter.encrypt(text, iv: iv); // encrypts text and stores associated iv

  await storage.write(key: "secure_data", value: "${iv.base64}:${encrypted.base64}"); // store iv and encrypted data in one string
}




// ******************************** Module 5 Code *************************************
Future<String> decryptStoredData() async {
  String? storedData = await storage.read(key: "secure_data");

  if (storedData != null && storedData.contains(":")) {
    final parts = storedData.split(":");
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedData = encrypt.Encrypted.fromBase64(parts[1]);

    return encrypter.decrypt(encryptedData, iv: iv);
  }
  return "No Data Found";
}




// ******************************** Module 6 Code *************************************
String idGeneration() { // function to generate and return uuid
  var uuid = Uuid(); // call Uuid() function and set as variable uuid
  return uuid.v4(); // return uuid generated
}



Future<void> requestPermission() async { // function to request permission before storage
  if (await Permission.storage.request().isGranted) { // request permission to store. if True...
    print("Storage permission granted"); // if permission is granted, display to user
  } else {
    print("Storage permission denied"); // if permission is denied, display message to user
  }
}
