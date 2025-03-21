import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../screens/screens.dart';

class HTimeApp extends ConsumerStatefulWidget {
  const HTimeApp({super.key});

  @override
  ConsumerState<HTimeApp> createState() => _HTimeAppState();
}

class _HTimeAppState extends ConsumerState<HTimeApp> {
  @override
  void initState() {
    super.initState();
    // Charger les tâches au démarrage
    Future.microtask(
        () => ref.read(taskNotifierProvider.notifier).refreshTasks());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: HomeScreen(),
      ),
    );
  }

//AppSlideBar(),
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
