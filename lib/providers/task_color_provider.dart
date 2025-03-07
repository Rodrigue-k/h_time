import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_color_provider.g.dart';

@riverpod
class SelectedTaskColor extends _$SelectedTaskColor {
  @override
  Color build() {
    return Colors.blue; // couleur par défaut
  }

  void setColor(Color color) {
    state = color;
  }
}