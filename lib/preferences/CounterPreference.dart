import 'package:shared_preferences/shared_preferences.dart';

class CounterPreference{

  void setIntValue(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int> getIntValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  void deleteKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

}