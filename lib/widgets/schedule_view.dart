import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_time/providers/providers.dart';

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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool viewMode = ref.watch(scheduleViewModeProvider);
    final dayBoxWidth = (width - 215) / 7;
    final today = DateTime.now().weekday - 1;

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
          ..strokeWidth = 0.3;

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
