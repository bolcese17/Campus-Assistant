import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/authenticate.dart';
import 'package:campus_assistant/user_status.dart';
import 'package:campus_assistant/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    getIfAdmin();
  }

  void getIfAdmin() async {
    await UserStatus().getUserAdminStatus().then(
      (value) {
        setState(() {
          if (value != null) {
            isAdmin = value;
            debugPrint("Admin? $isAdmin");
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundGray,
        appBar: AppBar(
          backgroundColor: backgroundBlue,
          leading: GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, '/settings');
            },
            child: const Icon(
              Icons.settings,
              color: iconPurple,
              size: 40,
            ),
          ),
          centerTitle: true,
          title: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundColor: iconBlue,
              radius: 20,
              child: Icon(
                Icons.menu_sharp,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/CampusIcon.png'),
                    fit: BoxFit.contain,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child:
              ListView(padding: const EdgeInsets.all(10.0), children: <Widget>[
            //(isAdmin == true)? menuItem(context, Icons.person, 'Users', '/users'): const SizedBox(height: 0, width: 0),
            SizedBox(height: (isAdmin == true) ? 20 : 0),
            menuItem(context, Icons.location_on_sharp, 'Navigate', '/navigate'),
            const SizedBox(height: 20),
            menuItem(context, Icons.food_bank, 'Food Vendors', '/foodVendors'),
            const SizedBox(height: 20),
            menuItem(context, Icons.school, 'Professor Ratings', '/professor'),
            const SizedBox(height: 20),
            menuItem(context, Icons.bus_alert_sharp, 'Shuttle', '/shuttle'),
            const SizedBox(height: 20),
            menuItem(context, Icons.people_rounded, 'Resources', '/resources'),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: () async {
                  AuthFunct().signout();
                  await Navigator.pushNamedAndRemoveUntil(
                      context, '/login', ModalRoute.withName('/home'));
                },
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: iconBlue,
                    radius: 30,
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w500),
                  ),
                  iconColor: Colors.white,
                  textColor: textBlue,
                ))
          ]),
        ));
  }
}
