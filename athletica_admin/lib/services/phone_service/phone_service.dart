import 'package:shared_preferences/shared_preferences.dart';

class PhoneService{
  String phone='';
  Future<String> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('admin_phone')!;
    return phone;
  }
}