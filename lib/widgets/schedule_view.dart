import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/providers.dart';
import 'dart:async';

class ScheduleView extends ConsumerStatefulWidget {
  final double width;
  final double hourHeight;
  final double dayWidth;
  final Color lineColor;
  final Color textColor;
  const ScheduleView({
    super.key,
    this.width = 80,
    this.hourHeight = 100,
    this.dayWidth = 200,
    this.lineColor = Colors.grey,
    this.textColor = Colors.grey,
  });

  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool viewMode = ref.watch(scheduleViewModeProvider);
    int selectedColonne = ref.watch(selectedColonneProvider);
    //final dayBoxWidth = (width - 215) / 7;
    final dayBoxWidth = (width - 215 + 150) / 7;
    final today = DateTime.now().weekday - 1;
    final tasks = ref.watch(taskNotifierProvider);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width, // Largeur finie
          height: 24 * widget.hourHeight,
          child: Stack(
            children: [
              //Graduation de l'heure
              CustomPaint(
                size: Size(double.infinity, 24 * widget.hourHeight),
                painter: TimePaint(
                  hourHeight: widget.hourHeight,
                  dayWidth: viewMode ? dayBoxWidth * 7 : dayBoxWidth,
                  lineColor: widget.lineColor,
                  textColor: widget.textColor,
                ),
              ),

              //dessin de la l'indicateur
              CustomPaint(
                size: Size(double.infinity, 24 * widget.hourHeight),
                painter: CurrentTimePainter(
                  hourHeight: widget.hourHeight,
                  dayWidth: dayBoxWidth,
                  viewMode: viewMode,
                  today: today,
                ),
              ),

              Positioned.fill(
                child: Row(
                  children: [
                    Container(width: 65, color: Colors.transparent),
                    if (viewMode)
                      Container(
                        width: dayBoxWidth * 7,
                        height: 24 * widget.hourHeight,
                        color: Colors.grey.withValues(alpha: .2),
                      )
                    else
                      ...List.generate(
                        7,
                        (index) => GestureDetector(
                          onTap: () => setState(() {
                            if (kDebugMode) {
                              print('Clique');
                            }
                            ref.read(selectedColonneProvider.notifier).state =
                                index;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            width: dayBoxWidth,
                            height: 24 * widget.hourHeight,
                            color:
                                (index == today) || (selectedColonne == index)
                                    ? Colors.grey.withValues(alpha: .2)
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              //construire les taches
              buildTasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTasks() {
    final tasks = ref.watch(taskNotifierProvider).value ?? [];
    final dayBoxWidth = (MediaQuery.of(context).size.width - 215 + 150) / 7;
    final today = DateTime.now().weekday - 1;
    bool viewMode = ref.watch(scheduleViewModeProvider);

    return Stack(
      children: tasks.expand<Widget>((task) {
        if (viewMode && !task.days[today]) {
          return <Widget>[]; // Retourner une liste vide si la tâche ne correspond pas
        }

        final startY = (task.startTime.hour + task.startTime.minute / 60) *
            widget.hourHeight;
        final endY =
            (task.endTime.hour + task.endTime.minute / 60) * widget.hourHeight;
        final height = endY - startY;

        List<Widget> taskWidgets = [];
        for (int i = 0; i < task.days.length; i++) {
          if (!task.days[i]) continue;
          if (!viewMode || (viewMode && i == today)) {
            final double x = viewMode ? 65 : 65 + (i * dayBoxWidth);
            final width = viewMode ? dayBoxWidth * 7 : dayBoxWidth;

            final taskKey = GlobalKey();

            taskWidgets.add(
              Positioned(
                left: x,
                top: startY,
                width: width,
                height: height,
                child: GestureDetector(
                  onTap: () {
                    final keyContext = taskKey.currentContext!;
                    if (kDebugMode) {
                      print('Tâche cliquée : ${task.title}');
                    }

                    _showTaskDetailsDialog(task, keyContext);
                  },
                  child: Container(
                    key: taskKey,
                    decoration: BoxDecoration(
                      color: task.color.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        left: BorderSide(
                          color: task.color, // Bordure colorée à gauche
                          width: 4,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        task.title,
                        style: GoogleFonts.roboto(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return taskWidgets; // Retourne bien une liste de widgets
      }).toList(),
    );
  }

  final _popupKey = GlobalKey();
  Offset? _taskTapPosition;

void _showTaskDetailsDialog(Task task, BuildContext taskContext) async {
  final RenderBox renderBox = taskContext.findRenderObject() as RenderBox;
  final offset = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;

  setState(() {
    _taskTapPosition = Offset(
      offset.dx + size.width / 2,
      offset.dy + size.height / 2,
    );
  });

  await showDialog(
    context: context,
    builder: (context) {
      return Stack(
        children: [
          // Fond semi-transparent
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.black.withOpacity(0.6)), // Fond plus sombre pour un meilleur contraste
            ),
          ),
          // Positionnement du popup
          if (_taskTapPosition != null)
            Positioned(
              left: _taskTapPosition!.dx - 150, // Centré horizontalement
              top: _taskTapPosition!.dy - 100,  // Centré verticalement
              child: Material(
                color: Colors.transparent,
                child: Container(
                  key: _popupKey, // Clé préservée
                  width: 320, // Légèrement plus large pour un meilleur espacement
                  padding: const EdgeInsets.all(16), // Padding global
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Coins plus arrondis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // Ombre plus douce
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.shade200, // Bordure subtile
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Taille minimale pour éviter l'excès
                    children: [
                      // Flèche de positionnement
                      CustomPaint(
                        size: const Size(20, 10),
                        painter: _ArrowPainter(
                          color: Colors.white,
                          position: _taskTapPosition!,
                        ),
                      ),
                      // Titre avec une icône ou une barre colorée
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            color: task.color, // Barre verticale colorée
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              task.title,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Informations avec icônes
                      _buildInfoRow('Début:', task.startTime, icon: Icons.access_time),
                      _buildInfoRow('Fin:', task.endTime, icon: Icons.access_time_filled),
                      const SizedBox(height: 16),
                      // Jours de répétition
                      Text(
                        'Jours de répétition:',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8, // Espacement vertical entre les lignes
                        children: List.generate(
                          7,
                          (index) => Chip(
                            label: Text(
                              _dayName(index),
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: task.days[index] ? task.color : Colors.grey.shade600,
                              ),
                            ),
                            backgroundColor: task.days[index]
                                ? task.color.withOpacity(0.2)
                                : Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Chips arrondis
                              side: BorderSide(
                                color: task.days[index] ? task.color.withOpacity(0.5) : Colors.grey.shade300,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Boutons d'action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade600, // Couleur plus douce
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Annuler'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _editTask(task);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: task.color,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 2,
                            ),
                            child: const Text('Modifier'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(taskNotifierProvider.notifier).removeTask(task.id); // Suppression via Riverpod
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent, // Couleur rouge pour la suppression
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 2,
                            ),
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

// Méthode utilitaire pour les lignes d'information avec icônes
Widget _buildInfoRow(String label, TimeOfDay time, {IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${time.hour}h${time.minute.toString().padLeft(2, '0')}', // Utilisation du formatage existant
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

// Exemple pour _dayName (à adapter selon votre implémentation)
String _dayName(int index) {
  const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  return days[index];
}
  void _editTask(Task task) {
    // Créez des contrôleurs pour les champs de formulaire
    final titleController = TextEditingController(text: task.title);
    final startTimeController = TextEditingController(
      text:
          '${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')}',
    );
    final endTimeController = TextEditingController(
      text:
          '${task.endTime.hour}:${task.endTime.minute.toString().padLeft(2, '0')}',
    );

    // Créez une liste de booléens pour les jours sélectionnés
    final List<bool> selectedDays = List.from(task.days);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier la tâche'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: startTimeController,
                  decoration: InputDecoration(
                    labelText: 'Heure de début (HH:MM)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: task.startTime,
                    );
                    if (time != null) {
                      startTimeController.text =
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                    }
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: endTimeController,
                  decoration: InputDecoration(
                    labelText: 'Heure de fin (HH:MM)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: task.endTime,
                    );
                    if (time != null) {
                      endTimeController.text =
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Jours de répétition :',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
                ...List.generate(7, (index) {
                  return CheckboxListTile(
                    title: Text(_dayName(index)),
                    value: selectedDays[index],
                    onChanged: (value) {
                      setState(() {
                        selectedDays[index] = value!;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validez et enregistrez les modifications
                final newTitle = titleController.text.trim();
                final newStartTime = _parseTime(startTimeController.text);
                final newEndTime = _parseTime(endTimeController.text);

                if (newTitle.isEmpty ||
                    newStartTime == null ||
                    newEndTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Veuillez remplir tous les champs correctement')),
                  );
                  return;
                }

                final updatedTask = task.copyWith(
                  title: newTitle,
                  startTime: newStartTime,
                  endTime: newEndTime,
                  days: selectedDays,
                );

                ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

// Méthode utilitaire pour parser l'heure
  TimeOfDay? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

}

class TimePaint extends CustomPainter {
  final double hourHeight;
  final double dayWidth;
  final Color lineColor;
  final Color textColor;

  TimePaint({
    required this.hourHeight,
    required this.dayWidth,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.4;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int hour = 0; hour < 24; hour++) {
      final y = hour * hourHeight;
      canvas.drawLine(
        Offset(size.width - (size.width - 50), y),
        Offset(size.width, y),
        paint,
      );

      final quarterHeight = hourHeight / 4;
      for (int i = 1; i < 4; i++) {
        canvas.drawLine(
          Offset(size.width - (size.width - 55), y + (i * quarterHeight)),
          Offset(size.width - (size.width - 65), y + (i * quarterHeight)),
          paint,
        );
      }

      final timeText = TextSpan(
        text: '${hour.toString().padLeft(2, '0')}:00',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w300,
        ),
      );

      textPainter
        ..text = timeText
        ..layout();

      if (hour == 0) {
        textPainter.paint(canvas, Offset(5, y));
      } else {
        textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
      }
    }

    for (int day = 0; day < 7; day++) {
      final x = day * dayWidth;
      canvas.drawLine(Offset(x + 65, 0), Offset(x + 65, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant TimePaint oldDelegate) {
    return oldDelegate.hourHeight != hourHeight ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.textColor != textColor;
  }
}

class TaskPainter extends CustomPainter {
  final List<Task> tasks;
  final double hourHeight;
  final double dayWidth;
  final bool viewMode;
  final int selectedDay;

  TaskPainter({
    required this.tasks,
    required this.hourHeight,
    required this.dayWidth,
    required this.viewMode,
    required this.selectedDay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var task in tasks) {
      // Filtre les tâches en fonction du mode de vue
      if (viewMode && !task.days[selectedDay]) continue;

      // Calcul des positions
      final startY =
          (task.startTime.hour + task.startTime.minute / 60) * hourHeight;
      final endY = (task.endTime.hour + task.endTime.minute / 60) * hourHeight;
      final height = endY - startY;

      // Pour chaque jour où la tâche est programmée
      for (int i = 0; i < task.days.length; i++) {
        if (!task.days[i]) continue;
        if (!viewMode || (viewMode && i == selectedDay)) {
          final double x = viewMode ? 65 : 65 + (i * dayWidth);
          final width = viewMode ? dayWidth * 7 : dayWidth;

          // Dessin du rectangle de la tâche
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(x, startY, width.toDouble() - 1, height),
            Radius.circular(5),
          );

          // Dessin de l'ombre
          canvas.drawRRect(
            rect.shift(Offset(0, 1)),
            Paint()
              ..color = Colors.black.withValues(alpha: .1)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
          );

          // Dessin du fond
          canvas.drawRRect(
              rect, Paint()..color = task.color.withValues(alpha: 0.7));

          // Dessin de la bordure gauche colorée
          canvas.drawRRect(
            RRect.fromRectAndCorners(Rect.fromLTWH(x, startY, 8, height),
                topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            Paint()..color = task.color,
          );

          // Configuration du texte
          final textPainter = TextPainter(
            text: TextSpan(
              text: task.title,
              style: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.ltr,
          );

          textPainter.layout(maxWidth: width - 12);
          textPainter.paint(canvas, Offset(x + 8, startY + 8));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant TaskPainter oldDelegate) {
    return oldDelegate.tasks != tasks ||
        oldDelegate.hourHeight != hourHeight ||
        oldDelegate.dayWidth != dayWidth ||
        oldDelegate.viewMode != viewMode ||
        oldDelegate.selectedDay != selectedDay;
  }
}

class CurrentTimePainter extends CustomPainter {
  final double hourHeight;
  final double dayWidth;
  final bool viewMode;
  final int today;

  CurrentTimePainter({
    required this.hourHeight,
    required this.dayWidth,
    required this.viewMode,
    required this.today,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final currentY = (now.hour + now.minute / 60.0) * hourHeight;

    // Point rouge à gauche avec effet de glow
    final circlePaint = Paint()
      ..color = Colors.red
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(Offset(65.0, currentY), 4.0, circlePaint);

    // Ligne pointillée horizontale
    final dashPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.7)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Dessin des pointillés
    double startX = 65.0;
    final endX = size.width;
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, currentY),
        Offset(startX + dashWidth, currentY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }

    // Affichage de l'heure actuelle
    final timeText = TextSpan(
      text:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      style: GoogleFonts.roboto(
        fontSize: 11,
        color: Colors.red,
        fontWeight: FontWeight.w500,
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
    );

    final textPainter = TextPainter(
      text: timeText,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Dessin du fond blanc pour l'heure
    final textBackgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final textBackgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width - textPainter.width - 25,
        currentY - textPainter.height / 2 - 2,
        textPainter.width + 10,
        textPainter.height + 4,
      ),
      Radius.circular(2),
    );

    // Ajout d'une ombre légère derrière le texte
    canvas.drawRRect(
      textBackgroundRect.shift(Offset(1, 1)),
      Paint()
        ..color = Colors.black12
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
    );

    canvas.drawRRect(textBackgroundRect, textBackgroundPaint);

    // Dessin du texte
    textPainter.paint(
      canvas,
      Offset(
        size.width - textPainter.width - 20,
        currentY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CurrentTimePainter oldDelegate) {
    return true;
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final Offset position;

  _ArrowPainter({required this.color, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
