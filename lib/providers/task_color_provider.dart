import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../utils/color_constants.dart';

part 'task_color_provider.g.dart';

@riverpod
class SelectedTaskColor extends _$SelectedTaskColor {
  @override
  Color build() {
    return customColors.keys.first[500]!;
  }

  void selectedColor(Color color) {
    state = color;
  }

  Map<ColorSwatch<Object>, String> getCustomColors() {
    return customColors;
  }
}
