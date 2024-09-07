import 'package:cloud_firestore/cloud_firestore.dart';

import '../phone_service/phone_service.dart';

class HomeService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PhoneService _phoneService=PhoneService();
  String phone='';



  Future<void> initializeData(bool status) async {
    phone=await _phoneService.fetchData();
    await setStatus(status, phone);
  }

  Future<void> setStatus(bool status, String phone) async {
    await _firestore
        .collection('users')
        .doc(phone)
        .update({'isOnline': status});
  }
}