// ignore_for_file: non_constant_identifier_names

class Music {
  late int id;
  late String song_name;
  late String author_name;
  late int favourite_rating;
  late String song_image;

  Music({
    required this.id,
    required this.song_name,
    required this.author_name,
    required this.favourite_rating,
    required this.song_image,
  });

  void update(Music newMusic) {
    song_name = newMusic.song_name;
    author_name = newMusic.author_name;
    favourite_rating = newMusic.favourite_rating;
    song_image = newMusic.song_image;
  }

  void updateRating(int newRating) {
    favourite_rating = newRating;
  }

  int get Id => id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'song_name': song_name,
      'author_name': author_name,
      'favourite_rating': favourite_rating,
      'song_image': song_image,
    };
  }

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'],
      song_name: map['song_name'],
      author_name: map['author_name'],
      favourite_rating: map['favourite_rating'],
      song_image: map['song_image'],
    );
  }
}
