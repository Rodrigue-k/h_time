import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int value) => Color(value);

  @override
  int toJson(Color color) => color.value;
}
