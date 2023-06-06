import 'package:shared_preferences/shared_preferences.dart';

class UserStatus {
  // actual data
  static String userKey = 'uid';
  static String userNameKey = 'name';
  static String userEmailKey = 'email';
  static String userStatus = 'status';
  static String userAdmin = 'admin';

  // getting user data
  Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userKey);
  }

  Future<bool?> getUserAvailabilityStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userStatus);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  Future<bool?> getUserAdminStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userAdmin);
  }

  // setting user data
  static Future<bool> saveUserLoggedIn(bool loggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userKey, loggedIn);
  }

  static Future<bool> saveUserStatus(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userKey, status);
  }

  static Future<bool> saveUserName(String nameGiven) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, nameGiven);
  }

  static Future<bool> saveUserEmail(String emailGiven) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, emailGiven);
  }

  static Future<bool> saveUserAdminStatus(bool admin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userAdmin, admin);
  }
}
