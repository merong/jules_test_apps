import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/audio_player_provider.dart';
import '../widgets/song_tile.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategoryId == null ? 'Browse Genres' : 'Songs'),
        leading: _selectedCategoryId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedCategoryId = null;
                  });
                },
              )
            : null,
      ),
      body: _selectedCategoryId == null
          ? _buildCategoryGrid(songProvider)
          : _buildSongList(songProvider),
    );
  }

  Widget _buildCategoryGrid(SongProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategoryId = category.id;
            });
            provider.fetchSongsByCategory(category.id);
          },
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Icon(Icons.music_note, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSongList(SongProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: provider.currentCategorySongs.length,
      padding: const EdgeInsets.only(bottom: 80), // Space for mini player
      itemBuilder: (context, index) {
        final song = provider.currentCategorySongs[index];
        return SongTile(
          song: song,
          isDownloaded: song.isDownloaded,
          onDownload: () => provider.downloadSong(song),
          onPlay: () {
             Provider.of<AudioPlayerProvider>(context, listen: false)
                .playSong(song, provider.currentCategorySongs);
          },
        );
      },
    );
  }
}
