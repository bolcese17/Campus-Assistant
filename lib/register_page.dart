import 'package:campus_assistant/user_status.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:campus_assistant/colors.dart';

import 'firebase_code/authenticate.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String fullName = '';
  String password = '';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: backgroundBlue))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
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
                        const SizedBox(height: 5),
                        TextFormField(
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Times New Roman'),
                            decoration: textInputDecoration('Full Name',
                                const Icon(Icons.person, color: Colors.white)),
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter name";
                              } else {
                                return null;
                              }
                            }),
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
                          decoration: textInputDecoration('Email Address',
                              const Icon(Icons.email, color: Colors.white)),
                          onChanged: (value) {
                            setState(() {
                              value = value.toLowerCase();
                              email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Times New Roman'),
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Username length must be at least 6 characters long";
                            } else {
                              return null;
                            }
                          },
                          decoration: textInputDecoration('User Name',
                              const Icon(Icons.person, color: Colors.white)),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Times New Roman'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Username length must be at least 6 characters long";
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
                                register();
                              }, // add registration function
                              child: const Text("Register",
                                  style: TextStyle(
                                      fontSize: 20, color: textBlue))),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                              text: "Login",
                              style: const TextStyle(
                                  color: textPurple,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Times New Roman'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                }),
                        ),
                      ],
                    ))));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await AuthFunct()
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // _isLoading is still true
          await UserStatus.saveUserLoggedIn(true);
          await UserStatus.saveUserName(fullName);
          await UserStatus.saveUserEmail(email);
          await UserStatus.saveUserAdminStatus(false);
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
}

InputDecoration textInputDecoration(String text, Icon icon) {
  return InputDecoration(
    label: Text(text,
        style: const TextStyle(
            color: textPurple,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: 'Times New Roman')),
    fillColor: backgroundGray.withOpacity(0.2),
    filled: true,
    labelStyle: const TextStyle(color: Colors.white),
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
