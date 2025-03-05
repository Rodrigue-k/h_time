
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:h_time/utils/utils.dart';

class AppSlideBar extends StatelessWidget {
  const AppSlideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        children: [
          //_buildProgram(),
          SizedBox(height: 10),
          _buildNavItem(
            FontAwesomeIcons.calendarWeek,
            Colors.black,
            'calendrier',
          ),
          _buildNavItem(FontAwesomeIcons.listCheck, Colors.black, 'Taches'),
          //_buildNavItem(FontAwesomeIcons., Colors.black, 'Notes'),
        ],
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
            Icon(icon, color: color, size: 15),
            Text(name, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
