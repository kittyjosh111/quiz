import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

final ThemeData lightPurpleAmber = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple,
    primarySwatch: Colors.amber,
    iconTheme: IconThemeData(color: Colors.amber),
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        subtitle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54)));
final ThemeData lightIndigoPink = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    primarySwatch: Colors.pink,
    iconTheme: IconThemeData(color: Colors.pink),
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        subtitle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54)));
final ThemeData darkPinkBlueGrey = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.pink,
    iconTheme: IconThemeData(color: Colors.blueGrey),
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        subtitle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white70)));
final ThemeData darkPurpleGreen = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.purple,
    primarySwatch: Colors.green,
    iconTheme: IconThemeData(color: Colors.green),
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        subtitle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white70)));

class AppThemes {
  static const int LightPurpleAmber = 0;
  static const int LightIndigoPink = 1;
  static const int DarkPinkBlueGrey = 2;
  static const int DarkPurpleGreen = 3;
}

class ThemeItem {
  int id;
  String name, slug;
  ThemeData themeData;

  ThemeItem(this.id, this.name, this.slug, this.themeData);

  static List<ThemeItem> getThemeItems() {
    return <ThemeItem>[
      ThemeItem(AppThemes.LightPurpleAmber, 'Dark Purple & Amber(Light)',
          'light-purple-amber', lightPurpleAmber),
      ThemeItem(AppThemes.LightIndigoPink, 'Indigo & Pink(Light)',
          'light-indigo-pink', lightIndigoPink),
      ThemeItem(AppThemes.DarkPinkBlueGrey, 'Pink & BlueGrey(Dark)',
          'dark-pink-bluegrey', darkPinkBlueGrey),
      ThemeItem(AppThemes.DarkPurpleGreen, 'Purple & Green(Dark)',
          'dark-purple-green', darkPurpleGreen)
    ];
  }
}

final themeCollection = ThemeCollection(
  themes: {
    AppThemes.LightPurpleAmber: lightPurpleAmber,
    AppThemes.LightIndigoPink: lightIndigoPink,
    AppThemes.DarkPinkBlueGrey: darkPinkBlueGrey,
    AppThemes.DarkPurpleGreen: darkPurpleGreen,
  },
  fallbackTheme: ThemeData.light(),
);
