import 'dart:math';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserAuthService {
  Database? _database;
  String? _verificationCode = "";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'turizmuyg.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS User(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            surname TEXT,
            email TEXT,
            password TEXT
          )''',
        );
      },
      onOpen: (db) async {
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS User(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            surname TEXT,
            email TEXT,
            password TEXT
          )''',
        );
      },
    );
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('User', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      Map<String, dynamic> user = results.first;
      UserController userController = Get.find();
      userController.setUserId(user['id'].toString());
      userController.setUsername(user['name']);
      userController.setUserSurname(user['surname']);
      return results.first;
    }
    return null;
  }

   
  Future<void> checkEmail(RxString email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email.value],
    );
    print("Database sorgusu sonuçları: $results");

    if (results.isNotEmpty) {
      String verificationCode = _generateVerificationCode();
      print("Oluşturulan doğrulama kodu: $verificationCode");

      _verificationCode = verificationCode;

      try {
        await _sendEmail(email.value, verificationCode);
        print("E-posta gönderildi.");
      } catch (e) {
        print("E-posta gönderimi başarısız: $e");
      }
    } else {
      print("E-posta bulunamadı.");
    }
  }

  Future<void> _sendEmail(String email, String code) async {
    final smtpServer = gmail('mutlucanakgul@gmail.com', '12345678');
    final message = Message()
      ..from = const Address('mutlucanakgul@gmail.com', 'Turizmuyg')
      ..recipients.add(email)
      ..subject = 'Doğrulama Kodu'
      ..text = 'Doğrulama kodunuz: $code';

    try {
      final sendReport = await send(message, smtpServer);
      print('Mesaj gönderildi: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Mesaj gönderilemedi. Hata: ' + e.toString());
    }
  }

  bool verifyCode(String inputCode) {
    return inputCode == _verificationCode;
  }

  String _generateVerificationCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }
}

