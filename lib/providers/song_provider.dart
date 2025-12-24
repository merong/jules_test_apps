import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';

class SongProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DownloadService _downloadService = DownloadService();

  List<Category> _categories = [];
  List<Song> _currentCategorySongs = [];
  List<Song> _downloadedSongs = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  List<Song> get currentCategorySongs => _currentCategorySongs;
  List<Song> get downloadedSongs => _downloadedSongs;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSongsByCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentCategorySongs = await _apiService.getSongsByCategory(categoryId);
      // Check if they are already downloaded
      await _checkDownloadStatusForList(_currentCategorySongs);
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _checkDownloadStatusForList(List<Song> songs) async {
      // Inefficient O(N*M) but fine for small mock data
      final downloaded = await _downloadService.getDownloadedSongs(songs); // This is actually checking known songs vs files
      // But getDownloadedSongs returns a NEW list of Song objects.

      // Better approach: Get all downloaded songs first.
      // Since ApiService Mock Songs are the "Source of Truth" for ID:
      // We need a way to know if a specific ID is on disk.

      // Let's optimize:
      // just refresh the downloaded list first
      await fetchDownloadedSongs();

      for (var song in songs) {
          final isDown = _downloadedSongs.any((d) => d.id == song.id);
          song.isDownloaded = isDown;
          if (isDown) {
              song.localPath = _downloadedSongs.firstWhere((d) => d.id == song.id).localPath;
          }
      }
  }

  Future<void> fetchDownloadedSongs() async {
    // We need the list of ALL possible songs to check against files.
    // In a real app, this would be from a DB.
    // Here we hack it by fetching all "mock" songs from API service.
    // For now, let's just use the ones we have in memory or fetch a "master list".
    // I'll add a helper in ApiService or just iterate over all categories?
    // Let's assume we just check the current lists.
    // A better way for this mock:
    // ApiService could expose "getAllSongs".

    // For now, let's just simulate it by fetching all categories logic (simplified)
    // Actually, let's just instantiate a temporary full list from ApiService logic locally since it is hardcoded there.
    final allSongs = (await _apiService.getSongsByCategory('mock_all')); // Returns all in mock
    _downloadedSongs = await _downloadService.getDownloadedSongs(allSongs);
    notifyListeners();
  }

  Future<void> downloadSong(Song song) async {
    final path = await _downloadService.downloadSong(song);
    if (path != null) {
      song.isDownloaded = true;
      song.localPath = path;
      await fetchDownloadedSongs(); // Refresh library
      notifyListeners();
    }
  }
}
