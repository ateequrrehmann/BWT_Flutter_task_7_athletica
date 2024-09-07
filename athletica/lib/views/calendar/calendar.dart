import 'package:athletica/services/calendar_service/calendar_service.dart';
import 'package:athletica/services/phone_service/phone_service.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _notes = [];
  final TextEditingController _noteController = TextEditingController();
  Map<DateTime, List<dynamic>> _events = {};
  final CalendarService _calendarService = CalendarService();
  String? phone;
  final PhoneService _phoneService = PhoneService();

  fetchData() async {
    phone = await _phoneService.fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      _loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: tableTodayColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: tableSelectedColor,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: tableTodayTextStyleColor,
                ),
                selectedTextStyle: TextStyle(
                  color: tableSelectedTextStyleColor,
                ),
                markerDecoration: BoxDecoration(
                  color: tableMarkerDecorationColor,
                  shape: BoxShape.circle,
                ),
              ),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _notes = [];
                  _loadNotes();
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
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            if (_selectedDay != null) ...[
              Padding(
                padding: EdgeInsets.all(2.w),
                child: TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? savedNote = await _calendarService.saveNote(
                      _selectedDay!, _noteController.text);

                  if (savedNote != null) {
                    setState(() {
                      _notes.add(savedNote);
                      _noteController.clear();
                      _loadNotes();
                    });
                  } else {
                    reusableSnackBar(context, 'Failed to save note');
                  }
                },
                child: const Text('Save Note'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_notes[index]),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _loadNotes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(phone)
        .collection('notes')
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _events = {};
        for (var doc in snapshot.docs) {
          DateTime date = DateTime.parse(doc.id);

          List<String> notes;
          if (doc['notes'] is String) {
            notes = [doc['notes'] as String];
          } else if (doc['notes'] is List) {
            notes = List<String>.from(doc['notes']);
          } else {
            notes = [];
          }

          _events[date] = notes;
        }

        if (_selectedDay != null && _events[_selectedDay] != null) {
          _notes = List<String>.from(_events[_selectedDay]!);
        } else {
          _notes = [];
        }
      });
    } else {
      setState(() {
        _notes = [];
        _events = {};
      });
    }
  }
}
