import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../utils/middlewares.utils.dart';

Handler middleware(Handler handler) {
  return handler.use(isAuth).use(requestLogger());
}
