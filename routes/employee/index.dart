import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../models/employee.dart';
import '../../services/http_methods_service.dart';
import '../../services/mongo_db.service.dart';

FutureOr<Response?> onRequest(RequestContext context) {
  return HttpMethodsService.getCertainMethod(
    context,
    post: _onAddEmployee,
    get: _onGetEmployeeData,
  );
}

FutureOr<Response?> _onGetEmployeeData(RequestContext context) async {
  var queryParameters = context.request.uri.queryParameters;

  // For Certain Emploee With Id
  if (queryParameters.isNotEmpty && queryParameters['id'] != null) {
    try {
      var result = await MongoDbService.db
          .collection('emp')
          .findOne(where.id(ObjectId.fromHexString(queryParameters['id']!)));
      return Response.json(
        body: Employee.fromJson(result ?? {}).toJson(),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        body: 'Wrong Id',
        statusCode: HttpStatus.badRequest,
      );
    }
  }

  // For get All Emploee
  try {
    var result = await MongoDbService.db.collection('emp').find().toList();
    final employeeList = List<Employee>.from(result.map(Employee.fromJson));
    return Response.json(
      body: employeeList.map((e) => e.toJson()).toList(),
    );
  } catch (e) {
    return Response(
      body: 'No Data Found in collection emp',
      statusCode: HttpStatus.badRequest,
    );
  }
}

FutureOr<Response?> _onAddEmployee(RequestContext context) async {
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
    ..startDate = DateTime.now();
  await MongoDbService.db.collection('emp').insert(employee.toJson());

  return Response(
    body: 'Data Addedd Successfully',
    statusCode: HttpStatus.created,
    headers: {'content-type': 'application/json'},
  );
}
