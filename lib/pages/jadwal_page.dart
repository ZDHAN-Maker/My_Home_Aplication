import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _addEvent(DateTime date, String event) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (_events[dateKey] == null) {
      _events[dateKey] = [];
    }
    _events[dateKey]!.add(event);
    setState(() {});
  }

  void _showAddEventDialog(DateTime date) {
    String eventText = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Jadwal'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Masukkan nama acara'),
          onChanged: (value) {
            eventText = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (eventText.isNotEmpty) {
                _addEvent(date, eventText);
              }
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? DateTime.now())
                  .map((event) => ListTile(
                        title: Text(event),
                        leading: Icon(Icons.event),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedDay != null
          ? FloatingActionButton(
              onPressed: () => _showAddEventDialog(_selectedDay!),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
