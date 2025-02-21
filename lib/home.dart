import 'package:flutter/material.dart';
import 'package:h_time/calendar.dart';
import 'package:h_time/constant.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(children: [_buildSlidebar(), _buildContent()]));
  }

  Column _buildContent() {
    return Column(
        children: [
          _buildHeader(),
          Container()
          //Calendar(),
        ],
    );
  }

  Container _buildHeader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 7,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [Row(children: [

            ],
          )]),
    );
  }

  Widget _buildSlidebar() {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        children: [
          _buildProgram(),
          SizedBox(height: 10),
          _buildNavItem(
            Icons.calendar_view_week_outlined,
            Colors.black,
            'calendrier',
          ),
          _buildNavItem(Icons.task_alt_outlined, Colors.black, 'Taches'),
          _buildNavItem(Icons.note_outlined, Colors.black, 'Notes'),
        ],
      ),
    );
  }

  InkWell _buildProgram() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(05),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.arrow_drop_down, color: Colors.black, size: 13),
            Text(
              'Programme',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            Icon(Icons.add, color: Colors.green, size: 13),
          ],
        ),
      ),
    );
  }

  InkWell _buildNavItem(IconData? icon, Color color, String name) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 08),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Icon(icon, color: color, size: 20),
            Text(name, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
