import 'package:flutter/material.dart';

const Color primaryColor = Color(0xF1F2FBFF);
const Color secondaryColor = Color.fromARGB(240, 255, 255, 255);


/*const List<Color> taskColors = [
  Color(0xFFFF7B7B),
  Color(0xFFFFB677),
  Color(0xFFFFE577),
  Color(0xFF77FF8F),
  Color(0xFF77D6FF),
  Color(0xFF9C77FF),
  Color(0xFFFF77E4),
];*/

final Map<ColorSwatch<Object>, String> customColors = {
  ColorSwatch(0xFFFF0000, {'primary': Color(0xFFFF0000)}): 'Rouge',
  ColorSwatch(0xFF00FF00, {'primary': Color(0xFF00FF00)}): 'Vert',
  ColorSwatch(0xFF0000FF, {'primary': Color(0xFF0000FF)}): 'Bleu',
  // Ajoute d'autres couleurs selon tes besoins
};