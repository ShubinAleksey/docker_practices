import 'package:conduit/conduit.dart';
import 'package:dart_conduit/model/categories.dart';
import 'package:dart_conduit/model/history.dart';
import 'package:dart_conduit/model/user.dart';

class Finance extends ManagedObject<_Finance> implements _Finance {
  Map<String, dynamic> toJson() => asMap();
}

class _Finance {
  @primaryKey
  int? id;
  @Column()
  int? operationNumber;
  @Column()
  String? operationName;
  @Column()
  String? description;
  @Column(defaultValue: 'now()')
  DateTime? operationDate;
  @Column()
  double? transactionAmount;
  @Column(nullable: true, defaultValue: '0')
  int? logicalDel;
  @Relate(#financesList, isRequired: true, onDelete: DeleteRule.cascade)
  Categories? category;
  @Relate(#financesList, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;

  ManagedSet<History>? historyList;
}