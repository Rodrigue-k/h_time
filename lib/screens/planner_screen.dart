import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildSidebarItem('Programme', Icons.menu_book, true),
                _buildSidebarItem('Schedule', Icons.calendar_today, false),
                _buildSidebarItem('Lectures', Icons.library_books, false),
                _buildSidebarItem('Tâches', Icons.check_circle_outline, false),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xF1F2FBFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'H-Time',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Nouvelle leçon'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text('Premium'),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('d MMMM yyyy').format(DateTime.now()),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Calendar Grid
                Expanded(
                  child: _buildCalendarGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      onTap: () {},
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Days header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 75), // Time column
                ...List.generate(
                  7,
                  (index) => Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('E, d').format(
                          DateTime.now().add(Duration(days: index)),
                        ),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Time slots
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 75,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${index.toString().padLeft(2, '0')}:00',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                              height: 60,
                              child: CustomPaint(
                                painter: RuleGraduationPainter(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...List.generate(
                        7,
                        (dayIndex) => Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RuleGraduationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Dessiner les graduations
    for (int i = 0; i <= 12; i++) {
      double y = (size.height / 12) * i;
      double lineLength;
      
      if (i == 0 || i == 12) {
        lineLength = 15.0;
      } else if (i % 2 == 0) {
        lineLength = 10.0;
      } else {
        lineLength = 5.0;
      }
      
      canvas.drawLine(
        Offset(size.width - lineLength, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
