
import 'dart:ui';
import 'package:h_time/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_color_provider.g.dart';


@riverpod
class SelectedTaskColor extends _$SelectedTaskColor{

  @override
  Color build(){
    return taskColors[0];
  }

  void selectedColor(Color color){
    state = color;
  }
}