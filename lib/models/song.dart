class Song {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl;
  final String url; // Remote URL or Local Path depending on context
  bool isDownloaded;
  String? localPath;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.url,
    this.isDownloaded = false,
    this.localPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumArtUrl': albumArtUrl,
      'url': url,
      'isDownloaded': isDownloaded,
      'localPath': localPath,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      albumArtUrl: json['albumArtUrl'],
      url: json['url'],
      isDownloaded: json['isDownloaded'] ?? false,
      localPath: json['localPath'],
    );
  }
}
