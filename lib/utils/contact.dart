import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "Contact";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String phoneColumn = "phoneColumn";
final String emailColumn = "emailColumn";
final String imgColumn = "imgColumn";

class ContactUtils {
  static final ContactUtils _instance = ContactUtils.internal();
  factory ContactUtils() => _instance;
  ContactUtils.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contactsFloripa.db");
    return await openDatabase(path, version: 1, 
      onCreate: (Database db, int newVersion) async {
        await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $phoneColumn TEXT, $emailColumn TEXT, $imgColumn TEXT)"
        );
      }
    );
  }

  Future<Contact> save(Contact contact) async {
    Database _dbContact = await db;
    contact.id = await _dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> get(int id) async {
    Database _dbContact = await db;
    List<Map> maps = await _dbContact.query(
      contactTable,
      columns: [idColumn, nameColumn, phoneColumn, emailColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if(maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database _dbContact = await db;
    return await _dbContact.delete(
      contactTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Contact contact) async{
    Database _dbContact = await db;
    return _dbContact.update(
      contactTable,
      contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id]
    );
  }

  Future<List<Contact>> getAll() async {
     Database _dbContact = await db;
     List listMap = await _dbContact.rawQuery("SELECT * FROM $contactTable");
     List<Contact> listContact = [];
     for(Map map in listMap) {
       listContact.add(Contact.fromMap(map));
     }
     return listContact;
  }
}

class Contact {
  int id;
  String name;
  String phone;
  String email;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    phone = map[phoneColumn];
    email = map[emailColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      emailColumn : email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}