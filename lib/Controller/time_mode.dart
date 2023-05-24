import 'package:shared_preferences/shared_preferences.dart';

class TimeModeControl {
  final Future<SharedPreferences> _preferences = SharedPreferences.getInstance();
  Future<bool> getMode() async {
    final SharedPreferences pref = await _preferences;
    return pref.getBool('timeMode') ?? false;
  }

  setTimeMode({required bool mode}) async {
    final SharedPreferences pref = await _preferences;
    pref.setBool('timeMode', mode);
  }
}
