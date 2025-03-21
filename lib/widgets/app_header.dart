
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/providers.dart';
import 'package:h_time/utils/utils.dart';
import 'package:h_time/widgets/custom_color_piker.dart';
import 'package:h_time/widgets/widgets.dart';

class AppHeader extends ConsumerStatefulWidget {
  final Future<void> Function() handleCapture;
  const AppHeader({super.key, required this.handleCapture});
  @override
  ConsumerState<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends ConsumerState<AppHeader> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _title = '';
  String _description = '';
  TimeOfDay _startTime = TimeOfDay(hour: 15, minute: 30);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 30);

  final _formKey = GlobalKey<FormState>();

  List<bool> _selectedDays = List.generate(7, (index) => false);

  Future<TimeOfDay?> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    return picked;
  }

  void _submit() {
    final selectedColor = ref.read(selectedTaskColorProvider);
    if (kDebugMode) {
      print('Couleur sélectionnée : $selectedColor');
    } 
    if (_formKey.currentState!.validate()) {

      if (_endTime.hour < _startTime.hour ||
          (_endTime.hour == _startTime.hour &&
              _endTime.minute <= _startTime.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'heure de fin doit être après l\'heure de début'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_selectedDays.contains(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner au moins un jour'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final task = Task(
        id: DateTime.now().toString(),
        title: _title,
        description: _description,
        days: _selectedDays,
        startTime: _startTime,
        endTime: _endTime,
        color: taskColors[selectedColor],
      );

      //print('Tâche créée avec la couleur : ${task.color}');

      ref.read(taskNotifierProvider.notifier).addTask(task);
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
    int selectedColonne = ref.watch(selectedColonneProvider);
    final days = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];
    final dayBoxWidth = (width - 215 + 150) / 7;
    final today = DateTime.now().weekday - 1;

    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => buildShowDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.green[500],
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "New Task",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                Container(
                  height: 25,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: Colors.green[50],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => ref
                              .read(scheduleViewModeProvider.notifier)
                              .state = true,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topLeft: Radius.circular(10),
                                //bottomLeft: Radius.circular(10),
                              ),
                              border: viewMode
                                  ? Border.all(color: Colors.green[200]!)
                                  : null,
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
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => ref
                              .read(scheduleViewModeProvider.notifier)
                              .state = false,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topRight: Radius.circular(10),
                                //bottomRight: Radius.circular(10),
                              ),
                              border: !viewMode
                                  ? Border.all(color: Colors.green[200]!)
                                  : null,
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
                            ), 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await widget.handleCapture();
                      },
                      child: Container(
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Icon(FontAwesomeIcons.download, size: 15),
                      ),
                    ),
                    /*IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.shareFromSquare, size: 15),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings_outlined, size: 15),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                getFormattedDate(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
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
                            color: index == today || selectedColonne == index
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

  void buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    TaskTextField(
                      labelText: 'Titre',
                      maxLines: 1,
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une Tâche';
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
                      onChanged: (value) =>
                          setState(() => _description = value),
                    ),
                    
                    Consumer(
                    builder: (context, ref, child) {
                      final selectedColorIndex = ref.watch(selectedTaskColorProvider);
                      return CustomColorPicker(
                        selectedColorIndex: selectedColorIndex,
                        onColorSelected: (Color color) {
                          // Vous pouvez utiliser cette couleur si nécessaire
                          if (kDebugMode) {
                            print('Couleur sélectionnée : $color');
                          }
                        },
                      );
                    },
                  ),
             
                    DaySelector(
                      selectedDays: _selectedDays,
                      onChanged: (days) => setDialogState(
                        () => _selectedDays = days,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Début',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final picked = await _selectTime(
                                    context,
                                    true,
                                  );
                                  if (picked != null) {
                                    setDialogState(() {
                                      _startTime = picked;

                                      if (_startTime.hour > _endTime.hour ||
                                          (_startTime.hour == _endTime.hour &&
                                              _startTime.minute >=
                                                  _endTime.minute)) {
                                        int newHour = _startTime.hour + 2;

                                        if (newHour > 23) {
                                          newHour = 23;
                                        }
                                        _endTime = TimeOfDay(
                                          hour: newHour,
                                          minute: _startTime.minute,
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        _startTime.format(context),
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fin',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final picked = await _selectTime(
                                    context,
                                    false,
                                  );
                                  if (picked != null) {
                                    setDialogState(() {
                                      _endTime = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        _endTime.format(context),
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(onPressed: _submit, child: Text('Créer')),
          ],
        ),
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
