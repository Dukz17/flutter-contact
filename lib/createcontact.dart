import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateContact extends StatefulWidget {
  const CreateContact({Key? key}) : super(key: key);

  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  bool? _enrolledValue = false;
  bool? _scholarValue = false;

  String? _genderoption = "";
  bool _agree = false;

  List _courseList = ['BSIT','BSN','BSCRIM','BSCE'];
  String? _selectedCourse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Contact"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Fullname',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          // DropdownButton<String>(
          //   value: _selectedCourse,
          //   hint: const Text("SELECT COURSE"),
          //   isExpanded: true,
          //   items: _courseList.map((course){
          //     return DropdownMenuItem<String>(
          //       value: course,
          //       child: Text(course));
          //   }).toList(), 
          //   onChanged: (value){
          //     setState(() {
          //       _selectedCourse = value;
          //     });
          //   }),
          // GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       _enrolledValue = !_enrolledValue!;
          //     });
          //   },
          //   child: Row(
          //     children: [
          //       Checkbox(value: _enrolledValue, 
          //       onChanged: (newValue){
          //         setState(() {
          //           _enrolledValue = newValue!;
          //         });
          //       },
          //       ),
          //       Text("Currently Enrolled")
          //     ],
          //   ),
          // ),
          
          // GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       _scholarValue = !_scholarValue!;
          //     });
          //   },
          //   child: Row(
          //     children: [
          //       Checkbox(value: _scholarValue, 
          //       onChanged: (newValue){
          //         setState(() {
          //           _scholarValue = newValue!;
          //         });
          //       },),
          //       Text("Is Scholar")
          //     ],
          //   ),
          // ),
          // GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       _genderoption = _genderoption!;
          //     });
          //   },
          //   child: Row(
          //     children: [
          //       Radio(
          //         value: "Male",
          //         groupValue: _genderoption, 
          //         onChanged: (value){
          //           setState(() {
          //             _genderoption = value;
          //           });
          //         },
          //         ),
          //       Text("Male")
          //     ],
          //   ),
          // ),
          // Row(
          //   children: [
          //     Radio(
          //       value: "Female",
          //       groupValue: _genderoption, 
          //       onChanged: (value){
          //         setState(() {
          //           _genderoption = value;
          //         });
          //       },
          //       ),
          //     Text("Female")
          //   ],
          // ),
          // Row(
          //   children: [
          //     Switch(value: _agree, onChanged: (value){
          //       setState(() {
          //         _agree = value;
          //       }
          //       );
          //     }
          //     ),
          //     Text("I Agree to Terms & agreement")
          //   ],
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // ElevatedButton(onPressed: (){
          //    String msg = "Enrolled : $_enrolledValue Schollar: $_enrolledValue Gender: $_genderoption Terms : $_agree Course: $_selectedCourse";
          //    print(msg);
          // }, 
          // child: Text(
          //   "Show Result"
          // ),),
          ElevatedButton(
            onPressed: () {
              save();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Save",
                ),
              ],
            ),
          ),
        ],
        ),
      )),
    );
  }

  void save() async {
    Uri uri = Uri.parse('http://localhost/contact-api/contacts.php');

    Map<String, dynamic> jsonData = {
      'userId': userIdController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'group': groupController.text,
    };

    Map<String, dynamic> data = {
      'operation': "addContact",
      'json': jsonEncode(jsonData),
    };

    http.Response response = await http.post(
      uri,
      body: data
    );

    print(response.body);
  
    if (response.statusCode == 200) {
      if (response.body == 1.toString()) {
        showMessageBox(context, "Success!", "You have successfully Registered");
      } else {
        showMessageBox(context, "Error", "Registration Failed");
      }
    } else {
      showMessageBox(context, "Error",
          "The server returns a ${response.statusCode} error.");
    } 
  }

  void showMessageBox(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

}
