import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_color_provider.g.dart';

@riverpod
class SelectedTaskColor extends _$SelectedTaskColor {
  @override
  int build() {
    return 0; // Index de la couleur par défaut (rouge)
  }

  void selectColor(int index) {
    if (kDebugMode) {
      print('Index de couleur mis à jour dans le provider : $index');
    } 
    state = index;
  }
}