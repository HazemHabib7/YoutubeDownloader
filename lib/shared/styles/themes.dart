import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  dialogBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.black)
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: defaultColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),
    color: Colors.white,
    elevation: 0.0,
    titleSpacing: 14.0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: defaultColor,
      fontSize: 24.0,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(size: 30.0),
  ),

);

ThemeData darkTheme = ThemeData(
  drawerTheme: DrawerThemeData(
    backgroundColor: HexColor('333739'),
  ),
  dialogBackgroundColor: HexColor('333739'),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Colors.grey),
    prefixIconColor: Colors.grey,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.white),
    ),
  ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: HexColor('333739')),
  scaffoldBackgroundColor: HexColor('333739'),
  primarySwatch: defaultColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarBrightness: Brightness.light,
    ),
    color: HexColor('333739'),
    elevation: 0.0,
    titleSpacing: 8.0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: defaultColor,
      fontSize: 24.0,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(size: 30.0),
    backgroundColor: HexColor('333739'),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);