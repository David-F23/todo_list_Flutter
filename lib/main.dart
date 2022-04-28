import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/groups_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO LIST',
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.w900),
        )
      ),
      home: GroupsScreen(),
    );
  }
}