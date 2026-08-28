import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _unlockedKey = 'unlocked_level';
  static const _deathsKey = 'death_count';

  Future<int> unlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unlockedKey) ?? 1;
  }

  Future<int> deathCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_deathsKey) ?? 0;
  }

  Future<void> recordDeath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_deathsKey, (prefs.getInt(_deathsKey) ?? 0) + 1);
  }

  Future<void> completeLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_unlockedKey) ?? 1;
    final next = (level + 1).clamp(1, 120);
    if (next > current) await prefs.setInt(_unlockedKey, next);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedKey);
    await prefs.remove(_deathsKey);
  }
}
