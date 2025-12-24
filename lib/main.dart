import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'providers/song_provider.dart';
import 'providers/audio_player_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions at startup
  await _requestPermissions();

  runApp(const GachbomPlayerApp());
}

Future<void> _requestPermissions() async {
  // Request storage permissions
  await [
    Permission.storage,
    Permission.manageExternalStorage,
    // Android 13+ media permissions
    Permission.audio,
    Permission.notification,
  ].request();
}

class GachbomPlayerApp extends StatelessWidget {
  const GachbomPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongProvider()),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ],
      child: MaterialApp(
        title: 'Gachbom Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
