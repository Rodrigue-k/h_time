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
  Task? _popUpTask;
  Offset? _popUpPosition;

   Map<String, Offset> _activePopUps = {}; 

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
                runSpacing: 8.0, // Espacement vertical si les boutons passent à la ligne suivante
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Modifier la tâche: ${task.title}');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Boutons plus compacts
                      minimumSize: const Size(0, 36), // Taille minimale réduite
                    ),
                    child: const Text('Modifier'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(taskNotifierProvider.notifier).removeTask(task.id);
                      setState(() {
                        _activePopUps.remove(task.id);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                            color: (index == today) || (selectedColonne == index)
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
      if (viewMode && !task.days[today]) return <Widget>[]; // Retourner une liste vide si la tâche ne correspond pas

      final startY = (task.startTime.hour + task.startTime.minute / 60) * widget.hourHeight;
      final endY = (task.endTime.hour + task.endTime.minute / 60) * widget.hourHeight;
      final height = endY - startY;

      List<Widget> taskWidgets = [];
      for (int i = 0; i < task.days.length; i++) {
        if (!task.days[i]) continue;
        if (!viewMode || (viewMode && i == today)) {
          final double x = viewMode ? 65 : 65 + (i * dayBoxWidth);
          final width = viewMode ? dayBoxWidth * 7 : dayBoxWidth;

          // Position du centre de la tâche pour le pop-up
          final taskCenter = Offset(x + width / 2, startY + height / 2);

          taskWidgets.add(
            Positioned(
              left: x,
              top: startY,
              width: width,
              height: height,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_activePopUps.containsKey(task.id)) {
                      _activePopUps.remove(task.id); // Ferme le pop-up si déjà ouvert
                    } else {
                      _activePopUps[task.id] = taskCenter; // Ouvre le pop-up
                    }
                    if (kDebugMode) {
                      print('Tâche cliquée : ${task.title}, Pop-up : ${_activePopUps.containsKey(task.id)}');
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: task.color.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(5),
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

          // Ajouter le pop-up si la tâche est dans _activePopUps
          if (_activePopUps.containsKey(task.id)) {
            taskWidgets.add(_buildPopUp(task, _activePopUps[task.id]!));
          }
        }
      }
      return taskWidgets; // Retourne la liste des widgets (tâche + pop-up si actif)
    }).toList(),
  );
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
