import 'dart:convert';
import 'package:training/createcontact.dart';
import 'package:training/function/public_functions.dart';
import 'package:training/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactsList extends StatefulWidget {
  final int userId;
  final String userFullName;

  ContactsList({
    required this.userId,
    required this.userFullName
  });

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> _contactsList = [];
  List<dynamic> _groupsList = [
    {'grp_id': 0, 'grp_name': 'ALL GROUPS'}
  ];
  int selectedGroupId = 0;
  TextEditingController _searchController = new TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Contact> myList = await getContacts(search: false);
    _groupsList = _groupsList + await getGroups();
    setState(() {
      _contactsList = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Contacts",
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30.0),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateContact(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(children: [
            //search
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search Name",
                  ),
                ),
              ),
              IconButton(
                onPressed: ()async{
                  _contactsList = await getContacts(search: true);
                  setState(() {});
                }, 
                icon: Icon(Icons.search),
              ),
            ],
            ),
            //dropdown button
            FutureBuilder(
                future: getGroups(),
                builder: (context, snapShot) {
                  switch (snapShot.connectionState) {
                    case ConnectionState.waiting:
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Loading...")
                        ],
                      );
                    case ConnectionState.done:
                      if (snapShot.hasError) {
                        return Text("Error: ${snapShot.error}");
                      }
                      return groupsDropDownButton();

                    default:
                      return Text("Error: ${snapShot.error}");
                  }
                }),
            //list view
            Expanded(
              flex: 7,
              child: FutureBuilder(
                future: getContacts(),
                builder: (context, snapShot) {
                  switch (snapShot.connectionState) {
                    case ConnectionState.waiting:
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Loading...")
                        ],
                      );
                    case ConnectionState.done:
                      if (snapShot.hasError) {
                        return Text("Error: ${snapShot.error}");
                      }
                      return contactsListView();

                    default:
                      return Text("Error: ${snapShot.error}");
                  }
                }),
              ),
            Text(
              "Current User: ${widget.userFullName}",
              style: TextStyle(fontSize: 20.0),
            ),
          ]),
        ),
      ),
    );
  }

  Widget groupsDropDownButton(){
    return DropdownButton<int>(
      value: selectedGroupId,
      isExpanded: true,
      items: _groupsList.map((group){
        return DropdownMenuItem<int>(
          value: group['grp_id'],
          child: Text(group['grp_name']),
        );
      }).toList(),
      onChanged: (newValue) async{
        setState(() {
          selectedGroupId = newValue!;
        });
        _contactsList = await getContacts();
      });
  }

  Widget contactsListView() {
    return ListView.builder(
      itemCount: _contactsList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
              leading: Icon(Icons.phone),
              title: Text(_contactsList[index].name!),
              subtitle: Text(_contactsList[index].phone!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    showUpdateForm(index);
                  }, icon: Icon(Icons.edit_note)),
                  IconButton(onPressed: (){
                    showDeleteForm(index);
                  }, icon: Icon(Icons.delete)),
                ],
              ),
            ),
        );
      },
    );
  }

  Future<List<Contact>> getContacts({bool search = false}) async {
    String url = "http://localhost/contact-api/contacts.php";

    // final Map<String, dynamic> jsonData = {
    //   "userId": widget.userId.toString(),
    //   "groupId" : selectedGroupId,
    // };

    // var json = Contact.jsonData(userId: widget.userId, groupId: selectedGroupId).toJson();
    final Map<String, dynamic> json;
    if(search){
      json = {"searchKey": _searchController.text, "userId": widget.userId};
    }else{
      json = Contact.jsonData(userId: widget.userId, groupId: selectedGroupId)
        .toJson();
    }

    var operation = search ? "search" : "getContacts";

     final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };

    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      var contacts = jsonDecode(response.body);

      var contactList = List.generate(
        contacts.length, (index) => Contact.fromJson(contacts[index]));
      
      return contactList;
    } else {
      return [];
    }
  }

  Future<List> getGroups() async {
    String url = "http://localhost/contact-api/contacts.php";

     final Map<String, dynamic> queryParams = {
      "operation": "getGroups",
      "json": "",
    };

    http.Response response =
      await http.get(Uri.parse(url).replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      var groups = jsonDecode(response.body);
      return groups;
    } else {
      return [];
    }
  }

  void showUpdateForm(int index)
  {
    final formKey = GlobalKey<FormState>();
    String name = _contactsList[index].name!;
    String phone = _contactsList[index].phone!;
    String email = _contactsList[index].email!;
    String address = _contactsList[index].address!;
    int groupId = _contactsList[index].groupId!;
    int id = _contactsList[index].id!;
    int userId = _contactsList[index].userId!;

    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text("Update"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Contact Name"),
                initialValue: name,
                validator: (value)
                {
                  if(value == null || value.isEmpty){
                    return "Please enter contact name";
                  }
                  return null;
                },
                onSaved: (value)
                {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone Number"),
                initialValue: phone,
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                  {
                    return "Please enter contact number";
                  }
                  else if(value.length != 11){
                    return "Phone number must be 11 digits";
                  }
                  return null;
                },
                onSaved: (value)
                {
                  phone = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                initialValue: email,
                validator: (value)
                {
                  if(value == null || value.isEmpty){
                    return "Please enter email";
                  }
                  return null;
                },
                onSaved: (value)
                {
                  email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Home address"),
                initialValue: address,
                validator: (value)
                {
                  if(value == null || value.isEmpty){
                    return "Please enter email";
                  }
                  return null;
                },
                onSaved: (value)
                {
                  address = value!;
                },
              ),
              SizedBox
              (
                height: 10.0,
              ),
              DropdownButtonFormField<int>(
                value: groupId,
                isExpanded: true,
                items: _groupsList.map((group){
                  return DropdownMenuItem<int>(
                    value: group['grp_id'],
                    child: Text(group['grp_name']),
                  );
                }).toList(),
                onChanged: (newValue) async{
                  setState(() {
                    groupId = newValue!;
                  });
                },
                validator: (value){
                  if(value == 0){
                    return "you must assign this contact to a group.";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async{
              if(formKey.currentState!.validate())
              {
                formKey.currentState!.save();
                Contact contact = Contact
                (
                  name: name,
                  phone: phone,
                  email: email,
                  groupId: groupId,
                  userId: userId,
                  address: address,
                  id: id,
                );
                if(await update(contact) == 1)
                {
                  Navigator.pop(context);
                  _contactsList = await getContacts();
                  setState(() {
                    
                  });
                  showMessageBox
                  (
                    context, "Success!", "Record Successfully update."
                  );
                }
                else 
                {
                  showMessageBox
                  (
                    context, "Update Failed!", "Record Not updated."
                  );
                }
              }
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
  }

  Future<int> update(Contact contact)async
  {
    Uri uri = Uri.parse('http://localhost/contact-api/contacts.php');

    Map<String, dynamic> jsonData = contact.toJson2();

    Map<String, dynamic> data = {
      'operation': "updateContact",
      'json': jsonEncode(jsonData), 
    };

    http.Response response = await http.post(
      uri,
      body: data
    );
  
    return int.parse(response.body);
  }
  
  void showDeleteForm(int index)
  {
    int id = _contactsList[index].id!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure want to delete ${_contactsList[index].name}?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async
              {
                if(await delete(id) == 1){
                  Navigator.pop(context);
                  _contactsList = await getContacts();
                  setState(() {
                    
                  });
                  showMessageBox(context, "Deleted", "Record has been successfully deleted.");
                }
                else
                {
                  showMessageBox(context, "Delete Failed", "Record has NOT been deleted.");
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<int> delete(int contactId)async
  {
    Uri uri = Uri.parse('http://localhost/contact-api/contacts.php');

    Map<String, dynamic> jsonData = {"id": contactId};

    Map<String, dynamic> data = {
      'operation': "deleteContact",
      'json': jsonEncode(jsonData), 
    };

    http.Response response = await http.post(
      uri,
      body: data
    );
  
    return int.parse(response.body);
  }
}