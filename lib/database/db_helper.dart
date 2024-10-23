import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/music_model.dart';

class DatabaseHelper {
  static const nameDB = 'todo_music.db';
  static const version = 2;

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(nameDB);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Lấy đường dẫn database
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: version, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    // Tạo bảng Music
    await db.execute('''
      CREATE TABLE musics (
        id $idType,
        song_name $textType,
        author_name $textType,
        favourite_rating int,
        song_image $textType
      )
    ''');

    // Tạo bảng Favourite
    await db.execute('''
      CREATE TABLE favourites (
        id $idType,
        music_id INTEGER
      )
    ''');
  }

  /// Music
  Future<void> insertMusic(Music music) async {
    final db = await instance.database;
    await db.insert('musics', music.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Music>> fetchAllMusic() async {
    final db = await instance.database;
    final maps = await db.query('musics');

    return List.generate(maps.length, (i) {
      return Music.fromMap(maps[i]);
    });
  }

  Future<int> updateMusic(Music music) async {
    final db = await instance.database;
    final musicId = music.id;
    return db.update(
      'musics',
      music.toMap(),
      where: 'id = ?',
      whereArgs: [musicId],
    );
  }

  Future<int> deleteMusic(int id) async {
    final db = await instance.database;
    return await db.delete(
      'musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Favourite
}
