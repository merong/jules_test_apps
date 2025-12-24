import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import '../models/song.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  AudioPlayer get player => _player;
  Song? get currentSong => _playlist.isNotEmpty && _currentIndex < _playlist.length ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  List<Song> get playlist => _playlist;

  AudioPlayerProvider() {
    _init();
  }

  void _init() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });

    _player.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });

    _player.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> playSong(Song song, List<Song> playlist) async {
    _playlist = playlist;
    _currentIndex = playlist.indexOf(song);
    if (_currentIndex == -1) {
        _playlist = [song];
        _currentIndex = 0;
    }

    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    if (_playlist.isEmpty) return;
    final song = _playlist[_currentIndex];

    try {
      // If downloaded, use file path, else use URL
      if (song.isDownloaded && song.localPath != null) {
          await _player.setFilePath(song.localPath!);
      } else {
          await _player.setUrl(song.url);
      }

      _player.play();

      // Update AudioService/Notification (Simplified for this snippet)
      // In a full implementation, you'd wrap this in an AudioHandler
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void playPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void skipToNext() {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _playCurrent();
    }
  }

  void skipToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _playCurrent();
    }
  }

  void seek(Duration position) {
    _player.seek(position);
  }
}
