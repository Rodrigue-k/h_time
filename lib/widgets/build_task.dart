

/*
// Construction de la fenêtre pop-up
  Widget _buildPopUp(Task task, Offset position) {
    double popUpWidth = 250.0; // Augmenté légèrement pour plus d'espace
    double popUpHeight = 180.0; // Ajusté pour accueillir les boutons en Wrap
    double left = position.dx - popUpWidth / 2;
    bool isAbove = position.dy - popUpHeight > 0;
    double top = isAbove ? position.dy - popUpHeight : position.dy;

    left = left.clamp(0.0, MediaQuery.of(context).size.width - popUpWidth);
    top = top.clamp(0.0, MediaQuery.of(context).size.height - popUpHeight);

    return Positioned(
      left: left,
      top: top,
      child: Stack(
        children: [
          Container(
            width: popUpWidth,
            height: popUpHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Début: ${task.startTime.format(context)}',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
                Text(
                  'Fin: ${task.endTime.format(context)}',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
                const Spacer(),
                // Remplacement du Row par un Wrap pour éviter l'overflow
                Wrap(
                  spacing: 8.0, // Espacement horizontal entre les boutons
                  runSpacing:
                      8.0, // Espacement vertical si les boutons passent à la ligne suivante
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print('Modifier la tâche: ${task.title}');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8), // Boutons plus compacts
                        minimumSize:
                            const Size(0, 36), // Taille minimale réduite
                      ),
                      child: const Text('Modifier'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(taskNotifierProvider.notifier)
                            .removeTask(task.id);
                        setState(() {
                          _activePopUps.remove(task.id);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('Supprimer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activePopUps.remove(task.id);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: popUpWidth / 2 - 10,
            bottom: isAbove ? -10 : null,
            top: isAbove ? null : -10,
            child: CustomPaint(
              painter: ArrowPainter(isAbove: isAbove),
              size: const Size(20, 10),
            ),
          ),
        ],
      ),
    );
  }

  class ArrowPainter extends CustomPainter {
  final bool isAbove;

  ArrowPainter({required this.isAbove});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    if (isAbove) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


*/