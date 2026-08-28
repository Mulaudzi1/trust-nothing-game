import 'dart:ui';
import 'models.dart';

class LevelCatalog {
  static const int levelCount = 120;

  static LevelData byId(int id) {
    assert(id >= 1 && id <= levelCount);
    final world = ((id - 1) ~/ 20) + 1;
    final local = ((id - 1) % 20) + 1;
    final traps = <TrapData>[
      TrapData(
        rect: Rect.fromLTWH(260 + (local % 4) * 75, 390, 42, 30),
        kind: local % 3 == 0 ? TrapKind.hiddenSpike : TrapKind.spike,
      ),
      if (local >= 4)
        TrapData(
          rect: Rect.fromLTWH(500 + (local % 3) * 60, 390, 55, 30),
          kind: local.isEven ? TrapKind.disappearingFloor : TrapKind.movingHazard,
        ),
      if (local >= 10)
        const TrapData(
          rect: Rect.fromLTWH(825, 330, 52, 70),
          kind: TrapKind.fakeExit,
        ),
    ];

    return LevelData(
      id: id,
      name: 'World $world · Level $local',
      spawn: const Offset(70, 350),
      exit: const Rect.fromLTWH(1010, 310, 58, 90),
      platforms: const [
        PlatformData(Rect.fromLTWH(0, 420, 1150, 80)),
        PlatformData(Rect.fromLTWH(330, 330, 130, 25)),
        PlatformData(Rect.fromLTWH(650, 285, 135, 25)),
      ],
      traps: traps,
    );
  }
}
