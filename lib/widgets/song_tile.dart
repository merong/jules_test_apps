import 'package:flutter/material.dart';
import '../models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final bool isDownloaded;
  final VoidCallback? onDownload;
  final VoidCallback onPlay;

  const SongTile({
    super.key,
    required this.song,
    required this.isDownloaded,
    required this.onDownload,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
            imageUrl: song.albumArtUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[300]),
            errorWidget: (context, url, error) => const Icon(Icons.music_note),
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: isDownloaded
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
              icon: const Icon(Icons.download),
              onPressed: onDownload,
            ),
      onTap: onPlay,
    );
  }
}
