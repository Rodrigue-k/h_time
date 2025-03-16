import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/providers/task_color_provider.dart';
import 'package:h_time/utils/constants.dart';

class CustomColorPicker extends ConsumerWidget {
  final int selectedColorIndex;
  final ValueChanged<Color> onColorSelected;

  const CustomColorPicker({
    super.key,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 couleurs par ligne
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: taskColors.length,
      itemBuilder: (context, index) {
        final color = taskColors[index];
        return GestureDetector(
          onTap: () {
            onColorSelected(color); // Appeler le callback avec la couleur sélectionnée
            ref.read(selectedTaskColorProvider.notifier).selectColor(index); // Mettre à jour l'index dans le provider
            print("Clique sur couleur : $color"); // Log de la couleur sélectionnée
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selectedColorIndex == index ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}