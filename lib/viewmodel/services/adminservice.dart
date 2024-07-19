import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AdminAddDataBase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'turizmuyg.db');
    _database = await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await _createSehirlerTable(db);
        await _createLokasyonlarTable(db);
        await _createFavorilerTable(db);
      },
      onOpen: (db) async {
        print('Veritabanı açıldı');
        await _checkAndCreateLokasyonlarTable(db);
        await _checkAndCreateFavorilerTable(db);

        await _checkAndCreateFavorilerTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createLokasyonlarTable(db);
        }
        if (oldVersion < 3) {
          await _createFavorilerTable(db);
        }
        if(oldVersion < 4){
          await _createYorumlarTable(db);
         
        }
      },
    );
    return _database!;
  }

  Future<void> _createSehirlerTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Sehirler(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sehirAdi TEXT
      )
    ''');
  }

  Future<void> _createLokasyonlarTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Lokasyonlar(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lokasyonAdi TEXT,
        lokasyonAdresi TEXT,
        sehir TEXT,
        icerik TEXT,
        icerikDili TEXT,
        image1 TEXT,
        image2 TEXT,
        image3 TEXT,
        image4 TEXT,
        image5 TEXT,
        puan REAL     
      )
    ''');
    print('Lokasyonlar table created');
  }

  Future<void> _createFavorilerTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Favoriler(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lokasyonId TEXT,
        kulId TEXT
      )
    ''');
    print("Favoriler tablosu oluşturuldu");
  }
  Future<void> _createYorumlarTable(Database db) async{
    await db.execute('''
       CREATE TABLE IF NOT EXISTS Yorumlar(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       kulId TEXT,
       yorum TEXT,
       lokasyonId TEXT,
       puan INTEGER)
     ''');
  }

  Future<void> _checkAndCreateLokasyonlarTable(Database db) async {
    final List<Map<String, dynamic>> tables = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', 'Lokasyonlar'],
    );

    if (tables.isEmpty) {
      await _createLokasyonlarTable(db);
    } else {
      print('Lokasyonlar table already exists');
    }
  }

  Future<void> _checkAndCreateFavorilerTable(Database db) async {
    final List<Map<String, dynamic>> tables = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', 'Favoriler'],
    );
    
    if (tables.isEmpty) {
      await _createFavorilerTable(db);
    } else {
      print('Favoriler table already exists');
    }
  }

  Future<void> insertSehir(String sehirAdi) async {
    final db = await database;
    await db.insert('Sehirler', {'sehirAdi': sehirAdi}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSehirler() async {
    final db = await database;
    return await db.query('Sehirler');
  }

  Future<void> insertLokasyon({
    required String lokasyonAdi,
    required String lokasyonAdresi,
    required String sehir,
    required String icerik,
    required String icerikDili,
    required List<String> images,
  }) async {
    final db = await database;
    await db.insert('Lokasyonlar', {
      'lokasyonAdi': lokasyonAdi,
      'lokasyonAdresi': lokasyonAdresi,
      'sehir': sehir,
      'icerik': icerik,
      'icerikDili': icerikDili,
      'image1': images.length > 0 ? images[0] : '',
      'image2': images.length > 1 ? images[1] : '',
      'image3': images.length > 2 ? images[2] : '',
      'image4': images.length > 3 ? images[3] : '',
      'image5': images.length > 4 ? images[4] : '',
      'puan': 0.0
    });
  }
   Future<void> _checkAndCreateTables(Database db) async {
    await _checkAndCreateTable(db, 'Sehirler', _createSehirlerTable);
    await _checkAndCreateTable(db, 'Lokasyonlar', _createLokasyonlarTable);
    await _checkAndCreateTable(db, 'Favoriler', _createFavorilerTable);
  }

  Future<void> _checkAndCreateTable(
      Database db, String tableName, Function(Database) createTable) async {
    final List<Map<String, dynamic>> tables = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', tableName],
    );

    if (tables.isEmpty) {
      await createTable(db);
    } else {
      print('$tableName tablosu zaten mevcut');
    }
  }
  Future<void> addFavorite(String lokasyonId, RxString kulId) async {
    final db = await database;
    await db.insert('Favoriler', {
      'lokasyonId': lokasyonId,
      'kulId': kulId.value,
    });
  }

  Future<void> removeFavorite(String lokasyonId, RxString kulId) async {
    final db = await database;
    await db.delete('Favoriler', where: 'lokasyonId = ? AND kulId = ?', whereArgs: [lokasyonId, kulId.value]);
  }

  Future<bool> isFavorite(String lokasyonId, RxString kulId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Favoriler',
      where: 'lokasyonId = ? AND kulId = ?',
      whereArgs: [lokasyonId, kulId.value],
    );
    return maps.isNotEmpty;
  }
  Future<List<String>> getFavorite(RxString kulId) async{
    final db = await database;
    final List<Map<String,dynamic>> result = await db.query(
      'Favoriler',where: 'kulId = ?',
      whereArgs: [kulId.value],
    );
    return result.map((map) => map['lokasyonId'] as String).toList();
  }

}
