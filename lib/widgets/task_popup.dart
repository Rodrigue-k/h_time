import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskPopup extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Offset position;
  final double arrowPosition;

  const TaskPopup({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.position,
    required this.arrowPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Flèche du popup
                Positioned(
                  left: arrowPosition - 10,
                  top: -10,
                  child: CustomPaint(
                    painter: ArrowPainter(),
                    size: const Size(20, 10),
                  ),
                ),

                // Contenu du popup
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(task.description),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit),
                            label: const Text('Modifier'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete),
                            label: const Text('Supprimer'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
