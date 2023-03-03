import 'package:conduit/conduit.dart';
import 'package:dart_conduit/model/finance.dart';

class History extends ManagedObject<_History> implements _History {
  Map<String, dynamic> toJson() => asMap();
}

class _History {
  @primaryKey
  int? id;
  @Column()
  String? action;
  @Column(defaultValue: 'now()')
  DateTime? date;
  @Relate(#historyList, isRequired: false)
  Finance? finance;
}