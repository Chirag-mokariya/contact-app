import 'package:contacts/DbHelper/db_helper.dart';
import 'package:contacts/home.dart';
import 'package:contacts/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final emailctr = TextEditingController();
  final passwordctr = TextEditingController();
  String errorMsg = "";
  DBHelper dbClient = DBHelper.getInstance;

  Future<void> LoginUser() async {
    var user = await dbClient.fetchUser(emailctr.text, passwordctr.text);
    if (user != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("isLoggedIn", true);
      await pref.setInt("userId", user['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful"),
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    } else {
      setState(() {
        errorMsg = "Email or Password Incorrect!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE1C9C9FF),
      body: Center(
        child: Container(
          // width: 50,
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0x3CEFEEF6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Icon(Icons.person_pin, size: 100, color: Color(0xE15E5EBA)),
                SizedBox(height: 20),
                Text(
                  "Sign in to your account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: emailctr,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is Required";
                            }
                            if (!value.contains('@')) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordctr,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is Required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        errorMsg.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  errorMsg,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xE15151D3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                LoginUser();
                                setState(() {
                                  errorMsg = "";
                                });
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Don't have an account? "),
                            GestureDetector(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
