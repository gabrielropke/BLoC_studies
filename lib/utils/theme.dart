import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  Brightness platformBrightness;

  ThemeProvider(this.platformBrightness)
      : _themeData =
            platformBrightness == Brightness.light ? lightMode : darkMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  void updatePlatformBrightness(Brightness brightness) {
    platformBrightness = brightness;
    themeData = brightness == Brightness.light ? lightMode : darkMode;
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: MyColors().lightGray01,
    inversePrimary: MyColors().purple,
    secondary: MyColors().ultraDarkGray,
    secondaryContainer: MyColors().lightpurple,
    tertiary: MyColors().lightGray02,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: MyColors().ultraDarkGray,
    inversePrimary: MyColors().white,
    secondary: MyColors().white,
    secondaryContainer: MyColors().lightpurple,
    tertiary: MyColors().darkGray,
  ),
);
