import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../services/http_methods_service.dart';

FutureOr<Response?> onRequest(RequestContext context) {
  return HttpMethodsService.getCertainMethod(context, post: _onLogin);
}

FutureOr<Response?> _onLogin(RequestContext context) async {
  final bodyData = await context.request.body();
  final email = jsonDecode(bodyData)['email'];
  final password = jsonDecode(bodyData)['password'];

  final jwt = JWT(
    {'email': email, 'password': password},
  );

  final token = jwt.sign(SecretKey('secret passphrase'));

  return Response.json(body: {'token': token});
}
