import 'package:campus_assistant/firebase_code/authenticate.dart';
import 'package:campus_assistant/firebase_code/database.dart';
import 'package:campus_assistant/user_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: iconBlue))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
                          // CONSTRAINED BOX
                          height: 250.0,
                          width: 250.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/CampusIcon.png'),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        )),
                        /*Container(
                          // CONSTRAINED BOX
                          height: 250.0,
                          width: 250.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/CampusIcon.png'),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),*/
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Times New Roman'),
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please enter valid email ";
                          },
                          decoration: textInputDecoration(
                              'Email',
                              const Icon(
                                Icons.email,
                                color: Colors.white,
                              )),
                          onChanged: (value) {
                            setState(() {
                              value = value.toLowerCase();
                              email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Times New Roman'),
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password length must be at least 6 characters long";
                            } else {
                              return null;
                            }
                          },
                          decoration: textInputDecoration('Password',
                              const Icon(Icons.lock, color: Colors.white)),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          // width: double.infinity,
                          height: 40.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonPurple),
                              onPressed: () {
                                login();
                              },
                              child: const Text("Login",
                                  style: TextStyle(
                                      color: textBlue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Times New Roman'))),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                              text: "Register",
                              style: const TextStyle(
                                  color: textPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Times New Roman',
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                }),
                        ),
                      ],
                    ))));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await AuthFunct()
          .loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          // _isLoading is still true
          QuerySnapshot snap =
              await DatabaseFunct(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await UserStatus.saveUserLoggedIn(true);
          //print(snap.docs.length);
          //String temp = "${snap.docs[0]['fullName']}";
          //print(temp);
          await UserStatus.saveUserName(snap.docs[0]['fullName']);
          await UserStatus.saveUserEmail(email);
          await UserStatus.saveUserAdminStatus(snap.docs[0]['admin']);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: "OK",
                onPressed: () {},
                textColor: Colors.white,
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  InputDecoration textInputDecoration(String text, Icon icon) {
    return InputDecoration(
      label: Text(text,
          style: const TextStyle(
              color: textPurple,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              fontFamily: 'Times New Roman')),
      fillColor: backgroundGray.withOpacity(0.2),
      filled: true,
      prefixIcon: icon,
      focusedBorder: const OutlineInputBorder(
        //borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        //borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: backgroundBlue,
        width: 2,
      )),
    );
  }
}
