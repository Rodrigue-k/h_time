
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/screens/home.dart';
import 'package:h_time/widgets/widgets.dart';


class HTimeApp extends StatelessWidget{
  const HTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [AppSlideBar(), Home()],
        ),
      ),
    );
  }




  /*InkWell _buildProgram() {
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
  }*/




}


