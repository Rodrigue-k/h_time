
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final widthProvider = Provider<double>((ref) {
  throw UnimplementedError();
});

final dayBoxWith = Provider((ref) => (ref.watch(widthProvider) - 215) / 7);