import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  String? userid;
  dynamic users;
  final namectr = TextEditingController();
  final emailctr = TextEditingController();
  final phonectr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  Future<void> load() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("userid");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Color(0xE15E5EBA),
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Icon(Icons.person_pin, size: 150, color: Color(0xE15E5EBA)),
            SizedBox(height: 30),
            users == null
                ? CircularProgressIndicator()
                : Text(
                    users['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
            SizedBox(height: 20),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: null,
                  child: Icon(Icons.call_outlined, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.messenger_outlined, size: 30),
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Icon(Icons.videocam_rounded, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {},

                  child: Icon(Icons.email_outlined, size: 30),
                ),
              ],
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xE1D2D2E3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: namectr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xE1D2D2E3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Mobile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: phonectr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number is required";
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return "Phone number must be 10 digit";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xE1D2D2E3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: emailctr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!value.contains('@')) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
