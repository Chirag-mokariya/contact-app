import 'package:contacts/editcontact.dart';
import 'package:contacts/loginpage.dart';
import 'package:contacts/mycard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userid;
  dynamic users;
  List contacts = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> Logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isLoggedIn", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void AddContacts() {
    final _formKey = GlobalKey<FormState>();
    final cnamectr = TextEditingController();
    final cphonectr = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Contact",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cnamectr,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: cphonectr,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Cancel"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Icon(Icons.perm_contact_calendar_rounded),
        ),
        leadingWidth: 40,
        backgroundColor: Color(0xE15E5EBA),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logout?"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Logout();
                      },
                      child: Text("logout"),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.login_outlined, color: Colors.black),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddContacts();
        },
        backgroundColor: Color(0xE15E5EBA),
        child: Icon(Icons.add_ic_call_outlined, color: Colors.white),
      ),
      body: Column(
        children: [
          users == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(color: Color(0xE15E5EBA), width: 2),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xE15E5EBA),
                      child: Text(
                        users['name'][0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      users['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("My Card"),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyCard()),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xE15E5EBA),
                    ),
                  ),
                ),
          SizedBox(height: 20),
          contacts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quick_contacts_dialer_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No Contacts",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(0xE15E5EBA),
                              child: Text(
                                contacts[index]["cname"][0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(contacts[index]["cname"]),
                            subtitle: Text(contacts[index]["cphone"]),
                            trailing: IconButton(
                              icon: Icon(Icons.call, color: Colors.green),
                              onPressed: () {},
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditContact(contact: contacts[index]),
                                ),
                              );
                            },
                          ),
                          Divider(color: Colors.black12, indent: 70),
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
