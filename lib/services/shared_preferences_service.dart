import 'package:shared_preferences/shared_preferences.dart';


final class SharedPreferencesService {
  late final SharedPreferences _sharedPreferences;

  Future<void> initStorage() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<T?> get<T>(String key) async {
    await initStorage();
    if (T is String) return _sharedPreferences.getString(key) as T?;
    if (T is bool) return _sharedPreferences.getBool(key) as T?;
    if (T is int) return _sharedPreferences.getInt(key) as T?;
    if (T is double) return _sharedPreferences.getDouble(key) as T?;
    if (T is List<String>) return _sharedPreferences.getStringList(key) as T?;
    return _sharedPreferences.get(key) as T?;
  }

  Future<void> set<T>({
    required String key,
    required T value,
  }) async {
    await initStorage();
    if (value is String) _sharedPreferences.setString(key, value);
    if (value is bool) _sharedPreferences.setBool(key, value);
    if (value is int) _sharedPreferences.setInt(key, value);
    if (value is double) _sharedPreferences.setDouble(key, value);
    if (value is List<String>)
      _sharedPreferences.setStringList(key, value);
  }

  Future<void> delete(String key) async {
    await initStorage();
    await _sharedPreferences.remove(key);
  }
}