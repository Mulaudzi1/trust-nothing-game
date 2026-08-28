import 'dart:ui';

enum TrapKind { spike, hiddenSpike, disappearingFloor, movingHazard, fakeExit }

class PlatformData {
  const PlatformData(this.rect);
  final Rect rect;
}

class TrapData {
  const TrapData({required this.rect, required this.kind});
  final Rect rect;
  final TrapKind kind;
}

class LevelData {
  const LevelData({
    required this.id,
    required this.name,
    required this.spawn,
    required this.exit,
    required this.platforms,
    required this.traps,
  });

  final int id;
  final String name;
  final Offset spawn;
  final Rect exit;
  final List<PlatformData> platforms;
  final List<TrapData> traps;
}
