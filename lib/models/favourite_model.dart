class Favourite {
  late int id;
  late int music_id;

  Favourite(this.music_id, this.id);

  Favourite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    music_id = map['music_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'music_id': music_id,
    };
  }
}
