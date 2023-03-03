import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration11 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_History", "finance", (c) {c.isNullable = true;c.deleteRule = DeleteRule.nullify;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    