

import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [AppHeader(), Expanded(child: ScheduleView())],
      ),
    );
  }
}
