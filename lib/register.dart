import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Registration"),
      // ),
      appBar: AppBar(
        title: Text(
          "User Registration",
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30.0),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),

      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: fullnameController,
            decoration: const InputDecoration(
              labelText: 'Fullname',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.abc),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
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
        ]),
      )),
    );
  }

  void save() async {
    Uri uri = Uri.parse('http://localhost/contact-api/users.php');

    Map<String, dynamic> jsonData = {
      'username': usernameController.text,
      'password': passwordController.text,
      'fullname': fullnameController.text
    };

    Map<String, dynamic> data = {
      'operation': "register",
      'json': jsonEncode(jsonData)
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
