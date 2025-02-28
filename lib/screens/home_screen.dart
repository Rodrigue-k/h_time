import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/screens/calendar_view.dart';
import 'package:h_time/screens/tasks_view.dart';
import 'package:h_time/screens/weekly_view.dart';
import 'package:h_time/theme/app_theme.dart';
import 'package:h_time/widgets/task_form_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<({String title, IconData icon, Widget screen})> _screens = const [
    (
      title: 'Vue Hebdomadaire',
      icon: Icons.calendar_view_week,
      screen: WeeklyView(),
    ),
    (
      title: 'Calendrier',
      icon: Icons.calendar_month,
      screen: CalendarView(),
    ),
    (
      title: 'Tâches',
      icon: Icons.task_alt,
      screen: TasksView(),
    ),
  ];

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaskFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'H-Time',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Bouton Nouvelle tâche
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: _showAddTaskDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Nouvelle Tâche'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Navigation items
                  for (var i = 0; i < _screens.length; i++)
                    _buildNavItem(
                      icon: _screens[i].icon,
                      title: _screens[i].title,
                      isSelected: _selectedIndex == i,
                      onTap: () => setState(() => _selectedIndex = i),
                    ),
                  const Spacer(),
                  // Profil utilisateur
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Utilisateur',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Gérer le profil',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            // TODO: Implémenter les paramètres
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenu principal
          Expanded(
            child: _screens[_selectedIndex].screen.animate().fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
