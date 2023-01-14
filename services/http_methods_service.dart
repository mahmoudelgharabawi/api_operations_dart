import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

class HttpMethodsService {
  static FutureOr<Response?> getCertainMethod(
    RequestContext context, {
    FutureOr<Response?> Function(
      RequestContext context,
    )?
        get,
    FutureOr<Response?> Function(
      RequestContext context,
    )?
        post,
    FutureOr<Response?> Function(
      RequestContext context,
    )?
        delete,
    FutureOr<Response?> Function(
      RequestContext context,
    )?
        put,
    FutureOr<Response?> Function(
      RequestContext context,
    )?
        patch,
  }) {
    switch (context.request.method) {
      case HttpMethod.post:
        return _tryCall(context, post?.call);
      case HttpMethod.delete:
        return _tryCall(context, delete?.call);
      case HttpMethod.get:
        return _tryCall(context, get?.call);
      case HttpMethod.head:
        return _notAllowed();
      case HttpMethod.options:
        return _notAllowed();
      case HttpMethod.patch:
        return _tryCall(context, patch?.call);
      case HttpMethod.put:
        return _tryCall(context, put?.call);
    }
  }

  static FutureOr<Response?> _tryCall(
    RequestContext context,
    FutureOr<Response?> Function(RequestContext)? funEx,
  ) {
    try {
      return funEx?.call(context) ?? _notAllowed();
    } catch (e) {
      return Response(
        body: jsonEncode({'error': e}),
        statusCode: HttpStatus.badRequest,
        headers: {'content-type': 'application/json'},
      );
    }
  }

  static Response _notAllowed() {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
