import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/audio_player_provider.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(context, listen: false).fetchDownloadedSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: songProvider.downloadedSongs.isEmpty
          ? const Center(
              child: Text('No downloaded songs yet.\nGo to Browse to download some!'),
            )
          : ListView.builder(
              itemCount: songProvider.downloadedSongs.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final song = songProvider.downloadedSongs[index];
                return SongTile(
                  song: song,
                  isDownloaded: true,
                  onDownload: null, // Already downloaded
                  onPlay: () {
                     Provider.of<AudioPlayerProvider>(context, listen: false)
                        .playSong(song, songProvider.downloadedSongs);
                  },
                );
              },
            ),
    );
  }
}
