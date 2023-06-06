import 'package:campus_assistant/firebase_code/database.dart';
import 'package:campus_assistant/widgets.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> subsetUserData = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserRawData();
  }

  void getUserRawData() async {
    await DatabaseFunct().getAllUserData().then((value) {
      setState(() {
        userData = value;
        subsetUserData = userData;
        //print(userData);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.person),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
                trailing: GestureDetector(
                    onTap: () {
                      _searchUsers();
                    },
                    child: const CircleAvatar(
                      backgroundColor: backgroundBlue,
                      radius: 30,
                      child: Icon(Icons.search, color: Colors.white, size: 30),
                    )),
                // left right top bottom are the parameters
                title: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundBlue, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundBlue, width: 2)),
                  ),
                  maxLines: null,
                  controller: _reviewController,
                  style: const TextStyle(color: Colors.black),
                )),
          ),
          (_isLoading == true)
              ? const CircularProgressIndicator(color: backgroundBlue)
              : (subsetUserData.isEmpty)
                  ? const Center(
                      child: Text(
                      "No User Found",
                      style: TextStyle(fontSize: 20),
                    ))
                  : Expanded(child: _userList(subsetUserData))
        ],
      ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> adminOptionDeleteUser(
      String id, String fullName, String email) async {
    TextEditingController textController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Are you sure you want to delete/disable $fullName\'s account?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please enter email $email to delete/disable."),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundBlue, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundBlue, width: 2)),
                  ),
                  maxLines: null,
                  controller: textController,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == email.trim()) {
                      return "Incorrect. Try Again";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: textBlue),
              ),
              onPressed: () {
                if (textController.text.trim() == email) {
                  //_deleteUser(id, fullName, email);
                  Navigator.of(context).pop();
                } else {
                  textController.clear();
                }
              },
            ),
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: textBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _searchUsers() {
    subsetUserData = List<Map<String, dynamic>>.from(userData);
    subsetUserData.removeWhere((element) {
      String val = element['fullName'] as String;
      val = val.toLowerCase();
      return !(val.contains(_reviewController.text.toLowerCase()));
    });

    // the above removes elements where textbox info not in the prof name
    setState(() {
      subsetUserData; // reloads page
    });
  }

  ListView _userList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
            color: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                //onTap: () {},
                title: Text(data[index]['fullName'] as String,
                    style: const TextStyle(fontFamily: "Times New Roman")),
                subtitle: Text(data[index]['email'] as String,
                    style: const TextStyle(fontFamily: "Times New Roman")),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //const Expanded(child: Spacer()),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonBlue),
                          onPressed: () {
                            adminOptionDeleteUser(
                                data[index]['id'] as String,
                                data[index]['fullName'] as String,
                                data[index]['email'] as String);
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Delete ",
                            ),
                          )),
                    ],
                  ))
            ]));
      },
    );
  }
}
