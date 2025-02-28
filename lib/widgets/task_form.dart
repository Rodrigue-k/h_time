import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskForm extends ConsumerStatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startTime;
  late DateTime _endTime;
  late bool _isRecurring;
  late List<bool> _recurringDays;
  late String _color;

  final List<String> _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _startTime = widget.task?.startTime ?? DateTime.now();
    _endTime = widget.task?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    _isRecurring = widget.task?.isRecurring ?? false;
    _recurringDays = widget.task?.recurringDays ?? List.filled(7, false);
    _color = widget.task?.color ?? Colors.blue.value.toRadixString(16);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        if (isStart) {
          _startTime = selectedDateTime;
          if (_startTime.isAfter(_endTime)) {
            _endTime = _startTime.add(const Duration(hours: 1));
          }
        } else {
          _endTime = selectedDateTime;
          if (_endTime.isBefore(_startTime)) {
            _startTime = _endTime.subtract(const Duration(hours: 1));
          }
        }
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task()
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..startTime = _startTime
        ..endTime = _endTime
        ..isRecurring = _isRecurring
        ..recurringDays = _recurringDays
        ..color = _color;

      if (widget.task != null) {
        task.id = widget.task!.id;
        task.uuid = widget.task!.uuid;
        ref.read(taskProvider.notifier).updateTask(task);
      } else {
        ref.read(taskProvider.notifier).addTask(task);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Heure de début'),
                    subtitle: Text(
                      DateFormat('HH:mm').format(_startTime),
                    ),
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Heure de fin'),
                    subtitle: Text(
                      DateFormat('HH:mm').format(_endTime),
                    ),
                    onTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Tâche récurrente'),
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                });
              },
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              const Text('Jours de répétition'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  return FilterChip(
                    label: Text(_weekDays[index]),
                    selected: _recurringDays[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _recurringDays[index] = selected;
                      });
                    },
                  );
                }),
              ),
            ],
            const SizedBox(height: 16),
            const Text('Couleur'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colorOptions.map((color) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _color = color.value.toRadixString(16);
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _color == color.value.toRadixString(16)
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.task == null ? 'Créer' : 'Mettre à jour'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
