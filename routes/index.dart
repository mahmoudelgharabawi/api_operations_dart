import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response? onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      return Response(body: 'Welcome to Dart Frog!');

    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
