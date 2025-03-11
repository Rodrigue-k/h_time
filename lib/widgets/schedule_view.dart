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
    final dayBoxWidth = (width - 215) / 7;
    final today = DateTime.now().weekday - 1;
    final tasks = ref.watch(taskNotifierProvider);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
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
                      (index) => Container(
                        width: dayBoxWidth,
                        height: 24 * widget.hourHeight,
                        color:
                            index == today
                                ? Colors.grey.withValues(alpha: .2)
                                : Colors.transparent,
                      ),
                    ),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size(double.infinity, 24 * widget.hourHeight),
            painter: TimePaint(
              hourHeight: widget.hourHeight,
              dayWidth: viewMode ? dayBoxWidth * 7 : dayBoxWidth,
              lineColor: widget.lineColor,
              textColor: widget.textColor,
            ),
          ),
          CustomPaint(
            size: Size(double.infinity, 24 * widget.hourHeight),
            painter: TaskPainter(
              tasks: tasks,
              hourHeight: widget.hourHeight,
              dayWidth: dayBoxWidth,
              viewMode: viewMode,
              selectedDay: today,
            ),
          ),
          CustomPaint(
            size: Size(double.infinity, 24 * widget.hourHeight),
            painter: CurrentTimePainter(
              hourHeight: widget.hourHeight,
              dayWidth: dayBoxWidth,
              viewMode: viewMode,
              today: today,
            ),
          ),
        ],
      ),
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
    final paint =
        Paint()
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
              ..color = Colors.black.withOpacity(0.1)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
          );

          // Dessin du fond
          canvas.drawRRect(rect, Paint()..color = task.color.withValues(alpha: 0.7));

          // Dessin de la bordure gauche colorée
          canvas.drawRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(x, startY, 8, height),
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5)),
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
    final circlePaint =
        Paint()
          ..color = Colors.red
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(Offset(65.0, currentY), 4.0, circlePaint);

    // Ligne pointillée horizontale
    final dashPaint =
        Paint()
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
    final textBackgroundPaint =
        Paint()
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
