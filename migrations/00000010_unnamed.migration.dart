import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration10 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Categories", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("categoryName", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true)]));
		database.createTable(SchemaTable("_Finance", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("operationNumber", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("operationName", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("operationDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, defaultValue: "now()", isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("transactionAmount", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("logicalDel", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, defaultValue: "0", isIndexed: false, isNullable: true, isUnique: false)]));
		database.createTable(SchemaTable("_History", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("action", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("date", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, defaultValue: "now()", isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("_Finance", SchemaColumn.relationship("category", ManagedPropertyType.bigInteger, relatedTableName: "_Categories", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false));
		database.addColumn("_Finance", SchemaColumn.relationship("user", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false));
		database.addColumn("_History", SchemaColumn.relationship("finance", ManagedPropertyType.bigInteger, relatedTableName: "_Finance", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    