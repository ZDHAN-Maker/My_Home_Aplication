import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Definisi tema warna futuristik
  final Color primaryColor = const Color(0xFF0D1B2A);
  final Color secondaryColor = const Color(0xFF1B263B);
  final Color accentColor = const Color(0xFF415A77);
  final Color highlightColor = const Color(0xFF778DA9);
  final Color textColor = Colors.white;
  final Color accentBlue = Colors.cyanAccent;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _selectedDay = _focusedDay;
  }

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
    _saveEvents();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _events.map((key, value) =>
        MapEntry(key.toIso8601String(), value));
    await prefs.setString('events', jsonEncode(data));
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('events');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      setState(() {
        _events = decoded.map((key, value) {
          final date = DateTime.parse(key);
          final events = List<String>.from(value);
          return MapEntry(date, events);
        });
      });
    }
  }

  // Dialog tambah event dengan tema futuristik
  void _showAddEventDialog(DateTime date) {
    String eventText = '';
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: accentBlue.withOpacity(0.5)),
            ),
            title: Text(
              'Tambah Jadwal',
              style: GoogleFonts.montserrat(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: GoogleFonts.montserrat(color: textColor),
                  cursorColor: accentBlue,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama acara',
                    hintStyle: GoogleFonts.montserrat(color: highlightColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: highlightColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                  onChanged: (value) {
                    eventText = value;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedTime == null
                            ? "Belum pilih jam"
                            : "Jam: ${selectedTime!.format(context)}",
                        style: GoogleFonts.montserrat(color: highlightColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: accentBlue,
                                  onPrimary: primaryColor,
                                  surface: secondaryColor,
                                  onSurface: textColor,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: accentBlue,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setStateDialog(() {
                            selectedTime = time;
                          });
                        }
                      },
                      child: Text("Pilih Jam", style: GoogleFonts.montserrat(color: accentBlue)),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: GoogleFonts.montserrat(color: highlightColor)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (eventText.isNotEmpty && selectedTime != null) {
                    final formattedEvent = "$eventText - ${selectedTime!.format(context)}";
                    _addEvent(date, formattedEvent);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: primaryColor,
                ),
                child: Text('Simpan', style: GoogleFonts.montserrat(color: primaryColor)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Jadwal', style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: secondaryColor,
        iconTheme: IconThemeData(color: textColor),
      ),
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
            // Styling Kalender
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.montserrat(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: accentBlue),
              rightChevronIcon: Icon(Icons.chevron_right, color: accentBlue),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.montserrat(color: textColor),
              weekendTextStyle: GoogleFonts.montserrat(color: highlightColor),
              todayDecoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: accentBlue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: GoogleFonts.montserrat(color: highlightColor),
              weekdayStyle: GoogleFonts.montserrat(color: highlightColor),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? DateTime.now())
                  .map((event) => ListTile(
                        title: Text(
                          event,
                          style: GoogleFonts.montserrat(color: textColor),
                        ),
                        leading: Icon(Icons.event, color: accentBlue),
                        tileColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: highlightColor.withOpacity(0.2)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minVerticalPadding: 10,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedDay != null
          ? FloatingActionButton(
              onPressed: () => _showAddEventDialog(_selectedDay!),
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add, color: Color(0xFF0D1B2A)),
            )
          : null,
    );
  }
}
