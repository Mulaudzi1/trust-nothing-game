import 'package:flutter_test/flutter_test.dart';
import 'package:trust_nothing_game/game/level_catalog.dart';

void main() {
  test('campaign contains 120 valid levels', () {
    for (var id = 1; id <= LevelCatalog.levelCount; id++) {
      final level = LevelCatalog.byId(id);
      expect(level.id, id);
      expect(level.platforms, isNotEmpty);
      expect(level.traps, isNotEmpty);
      expect(level.exit.width, greaterThan(0));
    }
  });
}
