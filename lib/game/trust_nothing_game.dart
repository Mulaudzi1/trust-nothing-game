import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import 'level_catalog.dart';
import 'models.dart';

class TrustNothingGame extends StatefulWidget {
  const TrustNothingGame({super.key, required this.level, required this.onExit});
  final int level;
  final VoidCallback onExit;

  @override
  State<TrustNothingGame> createState() => _TrustNothingGameState();
}

class _TrustNothingGameState extends State<TrustNothingGame> {
  static const double _gravity = 1500;
  static const double _speed = 260;
  static const double _jump = -610;
  final ProgressService _progress = ProgressService();
  Timer? _loop;
  late LevelData _level;
  Offset _position = Offset.zero;
  Offset _velocity = Offset.zero;
  bool _left = false;
  bool _right = false;
  bool _grounded = false;
  bool _dead = false;

  Rect get _player => Rect.fromLTWH(_position.dx, _position.dy, 34, 44);

  @override
  void initState() {
    super.initState();
    _level = LevelCatalog.byId(widget.level);
    _reset();
    _loop = Timer.periodic(const Duration(milliseconds: 16), (_) => _tick(0.016));
  }

  void _reset() => setState(() {
        _position = _level.spawn;
        _velocity = Offset.zero;
        _dead = false;
      });

  Future<void> _die() async {
    if (_dead) return;
    _dead = true;
    await _progress.recordDeath();
    if (mounted) Future<void>.delayed(const Duration(milliseconds: 450), _reset);
  }

  Future<void> _finish() async {
    await _progress.completeLevel(widget.level);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  void _tick(double dt) {
    if (!mounted || _dead) return;
    var vx = 0.0;
    if (_left) vx -= _speed;
    if (_right) vx += _speed;
    var next = Offset(_position.dx + vx * dt, _position.dy + (_velocity.dy + _gravity * dt) * dt);
    var vy = _velocity.dy + _gravity * dt;
    _grounded = false;

    final fallingPlayer = Rect.fromLTWH(next.dx, next.dy, 34, 44);
    for (final platform in _level.platforms) {
      if (fallingPlayer.overlaps(platform.rect) && _player.bottom <= platform.rect.top + 8 && vy >= 0) {
        next = Offset(next.dx, platform.rect.top - 44);
        vy = 0;
        _grounded = true;
      }
    }

    final nextPlayer = Rect.fromLTWH(next.dx, next.dy, 34, 44);
    for (final trap in _level.traps) {
      if (nextPlayer.overlaps(trap.rect)) {
        _die();
        return;
      }
    }
    if (nextPlayer.overlaps(_level.exit)) {
      _finish();
      return;
    }
    if (next.dy > 520 || next.dx < -60 || next.dx > 1160) {
      _die();
      return;
    }
    setState(() {
      _position = next;
      _velocity = Offset(vx, vy);
    });
  }

  void _doJump() {
    if (_grounded && !_dead) setState(() => _velocity = Offset(_velocity.dx, _jump));
  }

  @override
  void dispose() {
    _loop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10131A),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final sx = constraints.maxWidth / 1150;
          final sy = constraints.maxHeight / 500;
          return Stack(children: [
            CustomPaint(size: Size.infinite, painter: _GamePainter(_level, _player, sx, sy)),
            Positioned(top: 12, left: 16, child: Text(_level.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            Positioned(top: 6, right: 8, child: IconButton(onPressed: widget.onExit, icon: const Icon(Icons.close, color: Colors.white))),
            Positioned(left: 18, bottom: 18, child: Row(children: [
              _hold(Icons.arrow_left, (v) => _left = v),
              const SizedBox(width: 12),
              _hold(Icons.arrow_right, (v) => _right = v),
            ])),
            Positioned(right: 22, bottom: 18, child: GestureDetector(onTapDown: (_) => _doJump(), child: _button(Icons.keyboard_arrow_up))),
          ]);
        }),
      ),
    );
  }

  Widget _hold(IconData icon, void Function(bool) change) => GestureDetector(
        onTapDown: (_) => change(true),
        onTapUp: (_) => change(false),
        onTapCancel: () => change(false),
        child: _button(icon),
      );

  Widget _button(IconData icon) => Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .14), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white24)),
        child: Icon(icon, color: Colors.white, size: 38),
      );
}

class _GamePainter extends CustomPainter {
  _GamePainter(this.level, this.player, this.sx, this.sy);
  final LevelData level;
  final Rect player;
  final double sx;
  final double sy;

  Rect scale(Rect r) => Rect.fromLTWH(r.left * sx, r.top * sy, r.width * sx, r.height * sy);

  @override
  void paint(Canvas canvas, Size size) {
    final platformPaint = Paint()..color = const Color(0xFF3C465B);
    final dangerPaint = Paint()..color = const Color(0xFFE74C3C);
    final exitPaint = Paint()..color = const Color(0xFF49D17D);
    final playerPaint = Paint()..color = const Color(0xFFF4F6FA);
    for (final p in level.platforms) canvas.drawRRect(RRect.fromRectAndRadius(scale(p.rect), const Radius.circular(4)), platformPaint);
    for (final t in level.traps) {
      if (t.kind != TrapKind.hiddenSpike) canvas.drawRect(scale(t.rect), dangerPaint);
    }
    canvas.drawRect(scale(level.exit), exitPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(scale(player), const Radius.circular(6)), playerPaint);
  }

  @override
  bool shouldRepaint(covariant _GamePainter oldDelegate) => true;
}
