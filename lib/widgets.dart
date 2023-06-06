import 'package:campus_assistant/user_status.dart';
import 'package:flutter/material.dart';
import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/authenticate.dart';

bool isAdmin = false;

void getIfAdmin() async {
  await UserStatus().getUserAdminStatus().then(
    (value) {
      if (value != null) {
        isAdmin = value;
      }
    },
  );
}

// used to display the stars under a rating
Widget stars(num rating) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.star,
        color: (rating >= 1) ? iconBlue : Colors.grey,
        size: 30,
      ),
      Icon(
        Icons.star,
        color: (rating >= 2) ? iconBlue : Colors.grey,
        size: 30,
      ),
      Icon(
        Icons.star,
        color: (rating >= 3) ? iconBlue : Colors.grey,
        size: 30,
      ),
      Icon(
        Icons.star,
        color: (rating >= 4) ? iconBlue : Colors.grey,
        size: 30,
      ),
      Icon(
        Icons.star,
        color: (rating >= 5) ? iconBlue : Colors.grey,
        size: 30,
      ),
    ],
  );
}

// The APP Bar for all the pages except the login register and home page
// needs to be modified
AppBar appBarWidget(context, IconData icon) {
  return AppBar(
    backgroundColor: backgroundBlue,
    centerTitle: true,
    title: GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: iconBlue,
        radius: 20,
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
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
  );
}

GestureDetector menuItem(
    context, IconData icon, String text, String routeName) {
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBlue,
          radius: 30,
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w500),
        ),
        iconColor: Colors.white,
        textColor: textBlue,
      ));
}

Drawer drawerWidget(context) {
  getIfAdmin();
  return Drawer(
      backgroundColor: backgroundGray,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
        children: [
          /**
          DrawerHeader(
            decoration: const BoxDecoration(
              color: backgroundBlue,
            ),
            margin: const EdgeInsets.all(0.0),
            child: Container(),
          ),
           */
          /*ListTile(
            title: const Text('Home',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
            leading: const Icon(Icons.home),
          ), */
          //const SizedBox(height: 10),
          /*(isAdmin)
              ? ListTile(
                  title: const Text('Users',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                    Navigator.pushNamed(context, '/users');
                  },
                  leading: const Icon(Icons.person),
                )
              : const SizedBox(height: 0, width: 0),*/
          ListTile(
            title: const Text('Navigate',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/navigate');
            },
            leading: const Icon(Icons.location_on_sharp),
          ),
          //const SizedBox(height: 10),
          ListTile(
            title: const Text('Food Vendors',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/foodVendors');
            },
            leading: const Icon(Icons.food_bank),
          ),
          ListTile(
            title: const Text('Professor Ratings',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/professor');
            },
            leading: const Icon(Icons.school),
          ),
          ListTile(
            title: const Text('Shuttle',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/shuttle');
            },
            leading: const Icon(Icons.bus_alert_sharp),
          ),
          ListTile(
            title: const Text('Settings',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/settings');
            },
            leading: const Icon(Icons.settings),
          ),
          ListTile(
            title: const Text('Resources',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () async {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushNamed(context, '/resources');
            },
            leading: const Icon(Icons.people_rounded),
          ),
          ListTile(
            title: const Text('Sign Out',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () async {
              await AuthFunct().signout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', ModalRoute.withName('/home'));

              //Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
            leading: const Icon(Icons.exit_to_app),
          )
        ],
      ));
}

FloatingActionButton backButtonWidget(context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.pop(context);
    },
    backgroundColor: backgroundBlue,
    child: const CircleAvatar(
      backgroundColor: backgroundBlue,
      child: Icon(
        Icons.arrow_back_sharp,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}
