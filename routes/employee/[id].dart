import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../models/employee.dart';
import '../../services/http_methods_service.dart';
import '../../services/mongo_db.service.dart';

FutureOr<Response?> onRequest(RequestContext context, String id) {
  return HttpMethodsService.getCertainMethod(
    context,
    delete: (context) => _onDeleteEmployee(context, id),
    put: (context) => _onUpdateEmployee(context, id),
  );
}

FutureOr<Response?> _onDeleteEmployee(RequestContext context, String id) async {
  try {
    final result = await MongoDbService.db
        .collection('emp')
        .deleteOne(where.id(ObjectId.fromHexString(id)));

    if (result.success && result.nRemoved != 0) {
      return Response(
        body: 'Data Deleted Successfully',
        statusCode: HttpStatus.created,
        headers: {'content-type': 'application/json'},
      );
    } else {
      return Response(
        body: 'Not Found Record With Id : ${id}',
        statusCode: HttpStatus.badRequest,
        headers: {'content-type': 'application/json'},
      );
    }
  } catch (e) {
    return Response(
      body: 'Error While Deleting ${id} ${e}',
      statusCode: HttpStatus.badRequest,
      headers: {'content-type': 'application/json'},
    );
  }
}

FutureOr<Response?> _onUpdateEmployee(RequestContext context, String id) async {
  final bodyData = await context.request.body();
  final name = jsonDecode(bodyData)['name']?.toString();
  final age = int.tryParse(jsonDecode(bodyData)['age'].toString());
  final address = jsonDecode(bodyData)['address']?.toString();
  final salary = double.tryParse(jsonDecode(bodyData)['salary'].toString());

  final employee = Employee()
    ..name = name
    ..age = age
    ..address = address
    ..salary = salary
    ..updateDate = DateTime.now();

  final modifier = ModifierBuilder();
  for (final key in employee.toJson().keys) {
    if (employee.toJson()[key] != null) {
      modifier.set(key, employee.toJson()[key]);
    }
  }

  try {
    final result = await MongoDbService.db
        .collection('emp')
        .update(where.id(ObjectId.fromHexString(id)), modifier);

    if (result['updatedExisting'] as bool) {
      return Response(
        body: 'Data Updated Successfully',
        statusCode: HttpStatus.created,
        headers: {'content-type': 'application/json'},
      );
    } else {
      return Response(
        body: 'Error While Updating ${id}',
        statusCode: HttpStatus.badRequest,
        headers: {'content-type': 'application/json'},
      );
    }
  } catch (e) {
    return Response(
      body: 'Error While Updating ${id} ${e}',
      statusCode: HttpStatus.badRequest,
      headers: {'content-type': 'application/json'},
    );
  }
}
