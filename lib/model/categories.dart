import 'package:conduit/conduit.dart';
import 'package:dart_conduit/model/finance.dart';

class Categories extends ManagedObject<_Categories> implements _Categories {
  Map<String, dynamic> toJson() => asMap();
}

class _Categories {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? categoryName;
  ManagedSet<Finance>? financesList;
}