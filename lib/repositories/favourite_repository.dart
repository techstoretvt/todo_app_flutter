import 'package:todo_app/database/db_helper.dart';
import 'package:todo_app/models/favourite_model.dart';

class FavouriteRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> addFavourite(int musicId) async {
    await _databaseHelper.addFavourite(musicId);
  }

  Future<void> deleteFavourite(int musicId) async {
    await _databaseHelper.deleteFavourite(musicId);
  }

  Future<List<Favourite>> fetchFavouriteById(int musicId) async {
    return await _databaseHelper.fetchFavouriteById(musicId);
  }
}
