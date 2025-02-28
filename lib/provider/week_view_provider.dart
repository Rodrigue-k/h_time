

import 'package:flutter_riverpod/flutter_riverpod.dart';

final weekViewProvider = StateNotifierProvider<WeekViewProvider, bool>((ref) => WeekViewProvider());

class WeekViewProvider extends StateNotifier<bool>{
  WeekViewProvider() : super(true);

  void toggleWeekView(){
    state = !state;
  }
}
