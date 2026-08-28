import 'package:flutter/material.dart';
import 'game/trust_nothing_game.dart';
import 'services/progress_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TrustNothingApp());
}

class TrustNothingApp extends StatelessWidget {
  const TrustNothingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trust Nothing',
        theme: ThemeData.dark(useMaterial3: true).copyWith(scaffoldBackgroundColor: const Color(0xFF0D1016)),
        home: const HomeScreen(),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _progress = ProgressService();
  int _unlocked = 1;
  int _deaths = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final unlocked = await _progress.unlockedLevel();
    final deaths = await _progress.deathCount();
    if (mounted) setState(() { _unlocked = unlocked; _deaths = deaths; });
  }

  Future<void> _play(int level) async {
    await Navigator.of(context).push(MaterialPageRoute<bool>(builder: (_) => TrustNothingGame(level: level, onExit: () => Navigator.of(context).pop())));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('TRUST NOTHING'), centerTitle: true),
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('The level is lying to you.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 12),
            Text('Unlocked $_unlocked / 120  ·  Deaths $_deaths', textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton(onPressed: () => _play(_unlocked), child: Text('PLAY LEVEL $_unlocked')),
            const SizedBox(height: 18),
            Expanded(child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemCount: 120,
              itemBuilder: (_, i) {
                final level = i + 1;
                final enabled = level <= _unlocked;
                return FilledButton.tonal(onPressed: enabled ? () => _play(level) : null, child: Text('$level'));
              },
            )),
          ]),
        )),
      );
}
