import 'package:flutter/material.dart';
import 'package:novel_covid_19/global.dart';
import 'package:novel_covid_19/views/home_master.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets/constant.dart';
import 'custom_widgets/my_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white70,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

//void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
 /* SharedPreferences prefs = await SharedPreferences.getInstance();
  var isDarkTheme = prefs.getBool(SharedPreferencesKeys.isDarkTheme);
  ThemeData theme;
  if(isDarkTheme != null) {
    theme = isDarkTheme ? darkTheme : lightTheme;
  } else {
    theme = lightTheme;
  }*/
  /*runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(theme),
      child: MyApp(),
    ),*/
  void main() => runApp(MyApp());
 // );
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomePageMaster(),
    );
  }
}
