
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_conduit/controllers/app_auth_controller.dart';
import 'package:dart_conduit/controllers/app_finance_controller.dart';
import 'package:dart_conduit/controllers/app_history_controller.dart';
import 'package:dart_conduit/controllers/app_token_controller.dart';
import 'package:dart_conduit/controllers/app_user_controller.dart';
import 'model/categories.dart';
import 'model/finance.dart';
import 'model/history.dart';
import 'model/user.dart';


class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
  ..route('token/[:refresh]').link(() => AppAuthController(managedContext),
  )
  ..route('user')
  .link(AppTokenController.new)!
  .link(() => AppUserController(managedContext))

  ..route('history')
  .link(AppTokenController.new)!
  .link(() => HistoryController(managedContext))

  ..route('finance/[:id]')
  .link(AppTokenController.new)!
  .link(() => FinanceController(managedContext));

  PersistentStore _initDatabase() {
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? 'admin';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final databaseName = Platform.environment['DB_NAME'] ?? 'flutterApi';
    return PostgreSQLPersistentStore(
      username, password, host, port, databaseName);
  }
}
