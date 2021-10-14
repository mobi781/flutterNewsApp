// ignore_for_file: await_only_futures

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver {
  static String nameKey = "NAMEKEY";
  static String emailKey = "EMAILKEY";
  static String imgKey = "IMAGEKEY";
  static String logKey = "LOGINKEY";

  static Future<bool> saveName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setString(nameKey, userName);
  }

  static Future<bool> saveEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setString(emailKey, userEmail);
  }

  static Future<bool> saveImage(String userImage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setString(imgKey, userImage);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(nameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(emailKey);
  }

  static Future<String?> getImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(imgKey);
  }

  static Future<bool> saveLoginData(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(logKey, isUserLoggedIn);
  }

  static Future<bool?> getLogData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(logKey);
  }
}
