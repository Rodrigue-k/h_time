import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_time/screens/time_table.dart';
import 'package:h_time/const/constant.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _title = '';
  String _description = '';

  bool weekView = true; //TODO :provided

  final _formKey = GlobalKey<FormState>();

  _submit() {
    if (_formKey.currentState!.validate()) {
      print('Submit');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [_buildSlideBar(), Expanded(child: _buildContent())],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [_buildHeader(), Expanded(child: TimeTableScreen())],
    );
  }

  Container _buildHeader() {
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
                  onPressed:
                      () => showDialog(
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
                                      _buildTextField(
                                        'Titre',
                                        1,
                                        controller: _TitleController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer une matière';
                                          }
                                          return null;
                                        },
                                        onChanged:
                                            (value) =>
                                                setState(() => _title = value),
                                      ),
                                      _buildTextField(
                                        'Description',
                                        5,
                                        controller: _descriptionController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer une description';
                                          }
                                          return null;
                                        },
                                        onChanged:
                                            (value) => setState(
                                              () => _description = value,
                                            ),
                                      ),
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
                      ),
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
                    color: Colors.grey[400],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap:
                              () => setState(() {
                                weekView = !weekView;
                              }),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topLeft: Radius.circular(10),
                                //bottomLeft: Radius.circular(10),
                              ),
                              color:
                                  !weekView ? primaryColor : Colors.transparent,
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
                              () => setState(() {
                                weekView = !weekView;
                              }),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                                //topRight: Radius.circular(10),
                                //bottomRight: Radius.circular(10),
                              ),
                              color:
                                  weekView ? primaryColor : Colors.transparent,
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
          Row(
            children: [
              SizedBox(width: 60), // Même largeur que le Ruler
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final days = [
                      'Lun',
                      'Mar',
                      'Mer',
                      'Jeu',
                      'Ven',
                      'Sam',
                      'Dim',
                    ];
                    return Expanded(
                      child: Container(
                        //width: 50,
                        color: Colors.green.withValues(alpha: 0.1),
                        padding: EdgeInsets.only(bottom: 8),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          days[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    int? maxLines, {
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.roboto(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      //textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.roboto(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Widget _buildSlideBar() {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        children: [
          //_buildProgram(),
          SizedBox(height: 10),
          _buildNavItem(
            FontAwesomeIcons.calendarWeek,
            Colors.black,
            'calendrier',
          ),
          _buildNavItem(FontAwesomeIcons.listCheck, Colors.black, 'Taches'),
          //_buildNavItem(FontAwesomeIcons., Colors.black, 'Notes'),
        ],
      ),
    );
  }

  /*InkWell _buildProgram() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(05),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.arrow_drop_down, color: Colors.black, size: 13),
            Text(
              'Programme',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            Icon(Icons.add, color: Colors.green, size: 13),
          ],
        ),
      ),
    );
  }*/

  InkWell _buildNavItem(IconData? icon, Color color, String name) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 08),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Icon(icon, color: color, size: 15),
            Text(name, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _TitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
