import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_time/providers/providers.dart';
import 'package:h_time/providers/task_color_provider.dart';
import 'package:h_time/utils/utils.dart';
import 'package:h_time/widgets/widgets.dart';

class AppHeader extends ConsumerStatefulWidget {
  const AppHeader({super.key});
  @override
  ConsumerState<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends ConsumerState<AppHeader> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _title = '';
  String _description = '';

  final _formKey = GlobalKey<FormState>();

  _submit() {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('Submit');
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool viewMode = ref.watch(scheduleViewModeProvider);
    final days = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];
    final dayBoxWidth = (width - 215) / 7;
    final today = DateTime.now().weekday - 1;

    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => buildShowDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.green[100],
                    textStyle: GoogleFonts.roboto(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      Text("Nouvelle tâche"),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 25,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap:
                              () =>
                                  ref
                                      .read(scheduleViewModeProvider.notifier)
                                      .state = true,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topLeft: Radius.circular(10),
                                //bottomLeft: Radius.circular(10),
                              ),
                              color:
                                  viewMode ? primaryColor : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Jour",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ), //TODO: Add Text Style
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap:
                              () =>
                                  ref
                                      .read(scheduleViewModeProvider.notifier)
                                      .state = false,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topRight: Radius.circular(10),
                                //bottomRight: Radius.circular(10),
                              ),
                              color:
                                  !viewMode ? primaryColor : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Semaine",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ), //TODO: Add Text Style
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.download, size: 15),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.shareFromSquare, size: 15),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings_outlined, size: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text(
                getFormattedDate(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          Stack(
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
                          height: 25,
                          color: Colors.grey.withValues(alpha: .2),
                        )
                      else
                        ...List.generate(7, (index) {
                          return Container(
                            width: dayBoxWidth,
                            height: 25,
                            color:
                                index == today
                                    ? Colors.grey.withValues(alpha: .2)
                                    : Colors.transparent,
                          );
                        }),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(double.infinity, 25),
                painter: DayTableHeader(
                  days: viewMode ? [days[today]] : days,
                  dayWidth: viewMode ? dayBoxWidth * 7 : dayBoxWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Nouvelle tâche",
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            content: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    TaskTextField(
                      labelText: 'Titre',
                      maxLines: 1,
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une matière';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _title = value),
                    ),
                    TaskTextField(
                      labelText: 'Description',
                      maxLines: 5,
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        return null;
                      },
                      onChanged:
                          (value) => setState(() => _description = value),
                    ),
                    // ... dans buildShowDialog
                    //
                    creer une liste de couleur selectionnable pour les taches
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () => _submit(),
                child: Text("Ajouter"),
              ),
            ],
          ),
    );
  }
}

class DayTableHeader extends CustomPainter {
  final List<String> days;
  final double dayWidth;

  DayTableHeader({required this.dayWidth, required this.days});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.transparent;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < days.length; i++) {
      final x = i * dayWidth;

      Rect dayRect = Rect.fromLTWH(x + 65, 0, dayWidth, size.height);

      canvas.drawRect(dayRect, paint);

      final textSpan = TextSpan(
        text: days[i],
        style: GoogleFonts.inter(
          fontSize: 13,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter
        ..text = textSpan
        ..layout();

      textPainter.paint(
        canvas,
        Offset(
          (x + 65) + (dayWidth / 2) - (textPainter.width / 2),
          (size.height / 2) - (textPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
