import 'package:todo_app/database/db_helper.dart';
import 'package:todo_app/models/music_model.dart';

class MusicRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> addMusic(Music music) async {
    await _databaseHelper.insertMusic(music);
  }

  Future<void> editMusic(Music music) async {
    await _databaseHelper.updateMusic(music);
  }

  Future<void> deleteMusic(Music music) async {
    await _databaseHelper.deleteMusic(music.Id);
  }

  Future<List<Music>> fetchAllMusic() async {
    return await _databaseHelper.fetchAllMusic();
  }
}
