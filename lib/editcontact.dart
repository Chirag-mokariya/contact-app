import 'package:contacts/DbHelper/db_helper.dart';
import 'package:flutter/material.dart';

class EditContact extends StatefulWidget {
  final dynamic contact;

  const EditContact({super.key, required this.contact});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  dynamic current_contact;
  final namectr = TextEditingController();
  final phonectr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DBHelper dbClient = DBHelper.getInstance;

  @override
  void initState() {
    super.initState();
    current_contact = widget.contact;
    namectr.text = current_contact['name'];
    phonectr.text = current_contact['number'];
  }

  Future<void> deleteContact() async {
    int row = await dbClient.deleteContact(current_contact['id']);
    if (row > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Contact Deleted.")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  int row = await dbClient.updateContact(
                    namectr.text,
                    phonectr.text,
                    current_contact['id'],
                  );
                  if (row > 0) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Contact Updated.")));
                    Navigator.pop(context);
                  }
                }
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
            current_contact == null
                ? CircularProgressIndicator()
                : Text(
                    current_contact['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
            SizedBox(height: 20),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.messenger_outlined, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.call_outlined, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {},
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
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    deleteContact();
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
