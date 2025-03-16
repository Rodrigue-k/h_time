import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../utils/color_constants.dart';

part 'task_color_provider.g.dart';

@riverpod
class SelectedTaskColor extends _$SelectedTaskColor {
  @override
  int build() {
    return 0; // Index de la couleur par défaut (rouge)
  }

  void selectColor(int index) {
    print('Index de couleur mis à jour dans le provider : $index'); // Log de l'index mis à jour
    state = index;
  }
}