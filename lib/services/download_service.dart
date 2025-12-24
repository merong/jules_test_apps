import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<bool> requestPermission() async {
    // For Android 13+, permissions are more granular, but WRITE_EXTERNAL_STORAGE is deprecated.
    // However, saving to app-specific directory usually doesn't need runtime permission for newer Android.
    // We check just in case for older versions.
    if (Platform.isAndroid) {
       // Just a basic check.
       // In real apps targetting Android 13, manage READ_MEDIA_AUDIO etc.
       // Since we are saving to app documents, we often don't need explicit WRITE permission on modern Android.
       return true;
    }
    return true;
  }

  Future<String?> downloadSong(Song song) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/${song.id}.mp3';

      await _dio.download(song.url, savePath);
      return savePath;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  Future<bool> deleteSong(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }

  Future<List<Song>> getDownloadedSongs(List<Song> allKnownSongs) async {
      // In a real app, you would probably store metadata in a local database (SQLite/Hive).
      // Here, we scan the directory and match with known mock songs for simplicity,
      // or we just assume we persist the 'isDownloaded' state via SharedPrefs.
      // To keep it simple and robust for this mock:
      // We will look for files in the doc dir.

      final dir = await getApplicationDocumentsDirectory();
      List<Song> downloaded = [];

      // Since we don't have a DB, we only know about songs defined in ApiService.
      // But for the 'Library', we need metadata.
      // Strategy: We will just check if files exist for the known songs.

      for (var song in allKnownSongs) {
          final path = '${dir.path}/${song.id}.mp3';
          if (await File(path).exists()) {
              downloaded.add(Song(
                  id: song.id,
                  title: song.title,
                  artist: song.artist,
                  albumArtUrl: song.albumArtUrl,
                  url: path, // Play from local
                  isDownloaded: true,
                  localPath: path
              ));
          }
      }
      return downloaded;
  }
}
