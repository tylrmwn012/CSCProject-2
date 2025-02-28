
class SecureDataEntry { // initialize SecureDataEntry class
    String sensitiveInfo; // initialize sensitiveInfo string field
    String uniqueId;     // initialize uniqueId string field

    SecureDataEntry(this.sensitiveInfo, this.uniqueId); // initialize fields as instance variables
                                                        // so info can be passed in
    String display() { // initialize function display()
        return "ID: $uniqueId, Info: $sensitiveInfo"; // return the string
  }
}

void main() { // enter void main() to execute class
    SecureDataEntry entry = SecureDataEntry("12345", "ID"); // set entry information equal to the following

    print(entry.display()); // print display function with info from entry
}