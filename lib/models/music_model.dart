// ignore_for_file: non_constant_identifier_names

class Music {
  late final int? id;
  late final String song_name;
  late final String author_name;
  late final int favourite_rating;
  late final String song_image;

  Music({
    this.id,
    required this.song_name,
    required this.author_name,
    required this.favourite_rating,
    required this.song_image,
  });

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
