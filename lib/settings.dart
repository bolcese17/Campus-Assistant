import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/authenticate.dart';
import 'package:campus_assistant/firebase_code/database.dart';
import 'package:campus_assistant/widgets.dart';
import 'package:campus_assistant/user_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final formKey = GlobalKey<FormState>();
  String? inputtedCurrentPassword;
  String? inputtedNewPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.settings),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  //// CHANGE PASSWORD BUTTON ////
                  SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundBlue),
                          // this is the pop up for when you click
                          // the change password button.
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                        content: Column(children: [
                                          passwordFormField(
                                              'Current Password', true),
                                          passwordFormField(
                                              'New Password', false)
                                        ]),
                                        // change password button
                                        actions: <Widget>[
                                          TextButton(
                                            child:
                                                const Text("Change Password"),
                                            onPressed: () async {
                                              debugPrint("aiite bet:");
                                              debugPrint(
                                                  "${formKey.currentState!.validate()}");
                                              if (formKey.currentState!
                                                  .validate()) {
                                                debugPrint("goign");
                                                changePassword();
                                              }
                                            },
                                          )
                                        ]));
                          },
                          child: const Text("Change Password",
                              style: TextStyle(
                                  color: textPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Times New Roman')))),
                  const SizedBox(height: 20), // space
                  //// DELETE ACCOUNT BUTTON ////
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonGray),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (ctx) =>
                                  // are you sure popup
                                  AlertDialog(
                                      title: const Text("Are you sure?"),
                                      actions: <Widget>[
                                        // no button
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        // yes button
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () async {
                                            // deletes user
                                            await AuthFunct().deleteUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);

                                            // signs user out
                                            AuthFunct().signout();

                                            // pushes to login page
                                            await Navigator
                                                .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/login',
                                                    ModalRoute.withName(
                                                        '/home'));
                                          },
                                        ),
                                      ]));
                        },
                        child: const Text("Delete Account",
                            style: TextStyle(
                                color: textPurple,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Times New Roman'))),
                  ),
                ],
              ))),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // function to change the password
  changePassword() async {
    await checkInputtedCurrentPassword().then((correctPassword) async {
      if (correctPassword == true) {
        debugPrint("correct pass");
        FirebaseAuth.instance.currentUser!
            .updatePassword(inputtedNewPassword!)
            .then((_) {
          debugPrint("password successfully changed!");
          Navigator.pop(context);
        }).catchError((e) {
          debugPrint("password unsuccessfully changed!");
        });
      } else {
        debugPrint("$inputtedCurrentPassword! is not correct pass");
      }
    });
  }

  // password form field object
  passwordFormField(String backgroundText, bool isCurrentPassword) {
    return TextFormField(
        obscureText: true,
        decoration: InputDecoration(labelText: backgroundText),
        style: const TextStyle(
            color: textBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Times New Roman'),
        onChanged: (value) {
          setState(() {
            // flutter doesn't support pass by reference so ugly workaround
            if (isCurrentPassword) {
              inputtedCurrentPassword = value;
            } else {
              inputtedNewPassword = value;
            }
          });
        },
        validator: (value) {
          debugPrint("apsodihapsodfjasd");
          if (isCurrentPassword) {
            debugPrint("CURREN TAHHHH");
            if (!checkInputtedCurrentPassword()) {
              return "Current password is incorrect.";
            }
          } else {
            if (value!.length < 6) {
              debugPrint("AHHHHHHHH");
              return "Password length must be at least 6 characters long";
            }
          }
        });
  }

  checkInputtedCurrentPassword() async {
    // get email.
    await UserStatus().getUserEmail().then((email) async {
      // attempt to login w/ email & "current password" text field
      await AuthFunct()
          .loginUserWithEmailandPassword(email!, inputtedCurrentPassword!)
          .then((value) {
        if (value! == true) {
          return true;
        } else {
          return false;
        }
      });
    });
  }
}
