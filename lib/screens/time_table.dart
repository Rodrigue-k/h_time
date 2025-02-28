import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Ruler(
            width: 60,
            hourHeight: 150,
            lineColor: Colors.grey.shade400,
            textColor: Colors.grey.shade700,
          ),
          Expanded(
            child: SizedBox(
              height: 24 * 150,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 150,
                  childAspectRatio: 1,
                ),
                itemCount: 24 * 7,
                itemBuilder:
                    (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ruler extends StatelessWidget {
  final double width;
  final double hourHeight;
  final Color lineColor;
  final Color textColor;

  const Ruler({
    super.key,
    this.width = 100,
    this.hourHeight = 40,
    this.lineColor = Colors.grey,
    this.textColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CustomPaint(
        size: Size(100, 24 * hourHeight),
        painter: RulerPaint(
          hourHeight: hourHeight,
          lineColor: lineColor,
          textColor: textColor,
        ),
      ),
    );
  }
}

class RulerPaint extends CustomPainter {
  final double hourHeight;
  final Color lineColor;
  final Color textColor;

  RulerPaint({
    required this.hourHeight,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int hour = 0; hour < 24; hour++) {
      final y = hour * hourHeight;
      canvas.drawLine(Offset(size.width - 15, y), Offset(size.width, y), paint);

      final quarterHeight = hourHeight / 4;
      for (int i = 1; i < 4; i++) {
        canvas.drawLine(
          Offset(size.width - 10, y + (i * quarterHeight)),
          Offset(size.width, y + (i * quarterHeight)),
          paint,
        );
      }

      final timeText = TextSpan(
        text: '${hour.toString().padLeft(2, '0')}:00',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      );

      textPainter
        ..text = timeText
        ..layout();

      if(hour == 0){
        textPainter.paint(canvas, Offset(5, y));
      }else{
        textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
      }

    }
  }

  @override
  bool shouldRepaint(covariant RulerPaint oldDelegate) {
    return oldDelegate.hourHeight != hourHeight ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.textColor != textColor;
  }
}
