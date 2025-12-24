import '../models/category.dart';
import '../models/song.dart';

class ApiService {
  // Mock Data
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Electronic',
      coverUrl: 'https://picsum.photos/id/1/200/200',
    ),
    Category(
      id: '2',
      name: 'Pop',
      coverUrl: 'https://picsum.photos/id/2/200/200',
    ),
    Category(
      id: '3',
      name: 'Rock',
      coverUrl: 'https://picsum.photos/id/3/200/200',
    ),
  ];

  // Using SoundHelix free samples
  final List<Song> _mockSongs = [
    Song(
      id: '1',
      title: 'Song One',
      artist: 'SoundHelix',
      albumArtUrl: 'https://picsum.photos/id/10/200/200',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    Song(
      id: '2',
      title: 'Song Two',
      artist: 'SoundHelix',
      albumArtUrl: 'https://picsum.photos/id/11/200/200',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    Song(
      id: '3',
      title: 'Song Three',
      artist: 'SoundHelix',
      albumArtUrl: 'https://picsum.photos/id/12/200/200',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
     Song(
      id: '4',
      title: 'Song Four',
      artist: 'SoundHelix',
      albumArtUrl: 'https://picsum.photos/id/13/200/200',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
     Song(
      id: '5',
      title: 'Song Five',
      artist: 'SoundHelix',
      albumArtUrl: 'https://picsum.photos/id/14/200/200',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    ),
  ];

  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return _categories;
  }

  Future<List<Song>> getSongsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    // For simplicity, return same songs for all categories but shuffle them or pick subset
    if (categoryId == '1') return _mockSongs.sublist(0, 3);
    if (categoryId == '2') return _mockSongs.sublist(2, 5);
    return _mockSongs;
  }
}
