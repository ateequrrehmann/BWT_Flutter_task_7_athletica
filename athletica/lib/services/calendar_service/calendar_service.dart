import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarService {
  String? phone;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();

  Future<String?> saveNote(DateTime selectedDay, String note) async {
    phone = await _chatService.fetchPhone();
    if (note.isNotEmpty) {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(phone)
          .collection('notes')
          .doc(selectedDay.toString())
          .get();

      List<String> notes = [];
      if (snapshot.exists) {
        var notesData = snapshot['notes'];

        if (notesData is String) {
          notes = [notesData];
        } else if (notesData is List) {
          notes = List<String>.from(notesData);
        }
      }

      notes.add(note);

      await _firestore
          .collection('users')
          .doc(phone)
          .collection('notes')
          .doc(selectedDay.toString())
          .set({
        'notes': notes,
      });

      return note;
    }
    return '';
  }
}
