import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedColonneProvider =
    StateProvider<int>((ref) => DateTime.now().weekday - 1);
