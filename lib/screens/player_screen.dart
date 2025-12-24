import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<AudioPlayerProvider>(context);
    final song = playerProvider.currentSong;

    if (song == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Not Playing")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album Art
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                image: DecorationImage(
                   image: NetworkImage(song.albumArtUrl), // In real app, handle local images if downloaded
                   fit: BoxFit.cover,
                   onError: (exception, stackTrace) => const Icon(Icons.music_note, size: 100),
                )
              ),
              child: song.albumArtUrl.isEmpty ? const Icon(Icons.music_note, size: 100) : null,
            ),
            const SizedBox(height: 32),

            // Title & Artist
            Text(
              song.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Progress Bar
            Slider(
              value: playerProvider.position.inSeconds.toDouble(),
              min: 0,
              max: playerProvider.duration.inSeconds.toDouble() > 0
                   ? playerProvider.duration.inSeconds.toDouble()
                   : 1.0,
              onChanged: (value) {
                playerProvider.seek(Duration(seconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(playerProvider.position)),
                  Text(_formatDuration(playerProvider.duration)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 48),
                  onPressed: () => playerProvider.skipToPrevious(),
                ),
                IconButton(
                  icon: Icon(
                    playerProvider.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => playerProvider.playPause(),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 48),
                  onPressed: () => playerProvider.skipToNext(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
