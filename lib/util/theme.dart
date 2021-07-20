import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3F3F3),
    accentColor: Color(0xFFE5B53B),
    scaffoldBackgroundColor: Color(0xFFF3F3F3),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF3F3F3),
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFDD835),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(15.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(15.0))
    ),
    bottomAppBarColor: Color(0xFFE6E6E6),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color:Color(0xFFE5B53B),),
    ),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202022),
    accentColor: Color(0xFFE0B84F),
    scaffoldBackgroundColor: Color(0xFF202022),
    cardTheme: CardTheme(
      color: Color(0xFF2D2D2F),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF2D2D2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE0B84F),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(15.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(15.0))
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color:Color(0xFFE5B53B),),
    ),
    bottomAppBarColor: Color(0xFF171719),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF202022)));

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  late SharedPreferences prefs;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
     _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
      prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}
