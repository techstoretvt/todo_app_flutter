import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/models/music_model.dart';
import 'package:todo_app/repositories/music_repository.dart';

class MusicScopedModel extends Model {
  late Music music;
  late MusicRepository musicRepository = MusicRepository();

  MusicScopedModel(this.music);

  void changeMusic(Music music) async {
    this.music.update(music);
    await musicRepository.editMusic(music);
    notifyListeners();
  }

  void delete() async {
    await musicRepository.deleteMusic(music);
  }

  void update() {
    notifyListeners();
  }
}
