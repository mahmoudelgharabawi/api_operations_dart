import 'package:mongo_dart/mongo_dart.dart';

class Employee {
  Employee();
  Employee.fromJson(Map<String, dynamic> data) {
    id = (data['_id'] as ObjectId).$oid;
    name = data['name']?.toString();
    age = int.tryParse(data['age'].toString());
    address = data['address']?.toString();
    salary = double.tryParse(data['salary'].toString());
    startDate = DateTime.tryParse(data['startDate']?.toString() ?? '');
    updateDate = DateTime.tryParse(data['updateDate']?.toString() ?? '');
  }
  String? id;
  String? name;
  int? age;
  String? address;
  double? salary;
  DateTime? startDate;
  DateTime? updateDate;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'age': age,
        'address': address,
        'salary': salary,
        'startDate': startDate.toString(),
        'updateDate': updateDate.toString()
      };
}
