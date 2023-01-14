import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'services/mongo_db.service.dart';

Future<HttpServer> run(
  Handler handler,
  InternetAddress ip,
  int port,
) async {
  await MongoDbService.init();
  return serve(handler, ip, port);
}
