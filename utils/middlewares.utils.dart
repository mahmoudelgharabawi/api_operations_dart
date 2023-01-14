import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

FutureOr<Response> Function(RequestContext) isAuth(Handler handler) {
  // Execute code before request is handled.

  return (context) async {
    if (context.request.headers['authorization'] == null) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    try {
      final jwt = JWT.verify(
          context.request.headers['authorization']?.split('Bearer ').last ?? '',
          SecretKey('secret passphrase'));

      print('Payload: ${jwt.payload}');
    } catch (e) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    // Forward the request to the respective handler.
    final response = await handler(context);

    // Execute code after request is handled.
    print('=========================> Succseessfully Login');

    // Return a response.
    return response;
  };
}
