import 'dart:async';
 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
 
class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
 
  factory DatabaseHelper() => _instance;
 
  final String tableArticle = 'articleTable';
  final String columnId = 'id';
  final String star = 'star';
  final String type = 'type';
  final String dateTime = 'dateTime';
  final String token = 'token';
  final String status = 'status';//默认0未上传 1代表已经上传

  static Database _db;
  DatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
 
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'article.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableArticle($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $star TEXT, $type TEXT, $dateTime TEXT, $token TEXT, $status TEXT)');
  }


  Future<List> getDateAll() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT *,sum(token) as count FROM $tableArticle group by star order by status,id DESC');
    return result.toList();
  }


  //列表页数据
  Future<List> getAllByStatus(statusData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT *,count(star) as count FROM $tableArticle WHERE status= $statusData group by star order by star DESC');
    return result.toList();
  }



  //检查type是否存在
  Future<List> getExiststar(starData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableArticle WHERE star= \'$starData\'');
    return result.toList();
  }



  //模糊搜索type
  Future<List> getSearch(typeData,starData) async {
    var dbClient = await db;
    //print('SELECT * FROM $tableArticle WHERE type like \'%$typeData%\' LIMIT 0,10');
    var result = await dbClient.rawQuery('SELECT * FROM $tableArticle WHERE type like \'%$typeData%\' AND star= \'$starData\' LIMIT 0,10');
    return result.toList();
  }



  //检查type是否存在
  Future<List> getExisttype(typeData,starData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableArticle WHERE type= \'$typeData\' AND star= \'$starData\'');
    return result.toList();
  }

  //按订单号查找标签
  Future<List> getAllBystar(starData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableArticle WHERE star= \'$starData\' order by dateTime DESC');
    return result.toList();
  }

  //按订单号查找sscc标签总数
  Future<int> getAllBystarInfoSscc(starData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT count(star) as sum FROM $tableArticle WHERE star= \'$starData\' and token=10 order by dateTime DESC');
    return result.first['sum'];
  }

  //按订单号查找km数量
  Future<int> getAllBystarInfoKm(starData) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT count(star) as sum FROM $tableArticle WHERE star= \'$starData\' and token=1 order by dateTime DESC');
    return result.first['sum'];
  }




  //保存
  Future<int> savetype(type) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableArticle, type.toMap());
    return result;
  }

  //删除订单里的空值
  Future<int> deleteEmptystar(String starData) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableArticle WHERE  $star = \'$starData\' AND type =\'0\'');
  }

  //更新订单状态
  Future<int> updatestar(starData) async {
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE $tableArticle SET $status = 1 WHERE $star = \'$starData\'');
  }
  //更新订单号
  Future<int> editstar(starData,newstar) async {
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE $tableArticle SET $star = \'$newstar\' WHERE $star = \'$starData\'');
  }
 //删除标签
  Future<int> deletetype(String typeData,String starData) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableArticle WHERE $type = \'$typeData\' and $star = \'$starData\'');
  }

  //删除订单
  Future<int> deletestar(String starData) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableArticle WHERE  $star = \'$starData\'');
  }


  Future<int> deletetypeById(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableArticle WHERE $columnId = $id');
  }
//
//  Future<int> deleteAll() async {
//    var dbClient = await db;
//    return await dbClient.rawDelete('DELETE FROM $tableArticle WHERE $columnId >0');
//  }
 

 
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}