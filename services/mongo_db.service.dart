import 'package:mongo_dart/mongo_dart.dart';

class MongoDbService {
  static final db = Db('mongodb://localhost:27017/testDb');

  static Future<void> init() async {
    await db.open();
    print('database Configured Successfully');
  }
}
