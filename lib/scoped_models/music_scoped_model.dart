import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/models/music_model.dart';

class MusicScopedModel extends Model {
  late Music music;

  MusicScopedModel(this.music);

  void changeMusic(Music music) {
    music.id = music.id;
    music.song_name = music.song_name;
    music.author_name = music.author_name;
    music.favourite_rating = music.favourite_rating;
    music.song_image = music.song_image;

    notifyListeners();
  }
}
