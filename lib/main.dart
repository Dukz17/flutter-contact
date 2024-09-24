import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
import 'package:training/contacts_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _msg = '';
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30.0),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildTextField(
              controller: _usernameController,
              labelText: 'Username',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _passwordController,
              labelText: 'Password',
              isPassword: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            const SizedBox(height: 20),
            Text(
              _msg,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
              child: const Text(
                "No account yet? Sign Up here...",
                style: TextStyle(
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  void login() async {
    String url = "http://localhost/contact-api/users.php";

    final Map<String, dynamic> jsonData = {
      "username": _usernameController.text,
      "password": _passwordController.text
    };

    final Map<String, dynamic> queryParams = {
      "operation": "login",
      "json": jsonEncode(jsonData)
    };

    try {
      http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body); //return type list<Map>
        if (user.isNotEmpty) {
          //navigate to next page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactsList(
                  userId: user[0]['usr_id'],
                  userFullName: user[0]['usr_fullname']),
            ),
          );
        } else {
          setState(() {
            _msg = "Invalid Username or password.";
          });
        }
      } else {
        setState(() {
          _msg = "${response.statusCode} ${response.reasonPhrase}";
        });
      }
    } catch (error) {
      setState(() {
        _msg = "$error";
      });
    }
  }
}