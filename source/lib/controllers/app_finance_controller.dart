import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_conduit/model/finance.dart';
import 'package:dart_conduit/model/history.dart';
import 'package:dart_conduit/model/user.dart';
import 'package:dart_conduit/utils/app_response.dart';
import 'package:dart_conduit/utils/app_utils.dart';

class FinanceController extends ResourceController {
  FinanceController(this.managedContext);

  final ManagedContext managedContext;
//создание
  @Operation.post()
  Future<Response> createFinance(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Finance finance) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final user = await managedContext.fetchObjectWithID<User>(id);
      if (user == null) {
        throw AppResponse.badRequest(message: 'ошибка пользователя');
      }

      final qCreateFinance = Query<Finance>(managedContext)
        ..values.user!.id = id
        ..values.operationNumber = finance.operationNumber
        ..values.operationName = finance.operationName
        ..values.operationDate = DateTime.now()
        ..values.description = finance.description
        ..values.transactionAmount = finance.transactionAmount
        ..values.category!.id = finance.category!.id;
       
      final newFinance = await qCreateFinance.insert();

      final qCreateHistory = Query<History>(managedContext)
        ..values.action = "CREATE"
        ..values.date = DateTime.now()
        ..values.finance!.id = newFinance.id;  

      qCreateHistory.insert();

      newFinance.removePropertyFromBackingMap('user');
      newFinance.removePropertyFromBackingMap('category');

      return AppResponse.ok(
          body: newFinance, message: 'Финансовая сводка добавлена');
    } on QueryException catch (e) {
      return AppResponse.serverError(e,
          message: 'Ошибка создания финансовой сводки');
    }
  }

  @Operation.get('id')
  Future<Response> getFinanceById(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('id') int id) async {
    try {
      final userId = AppUtils.getIdFromHeader(header);
      final qGetFinance = Query<Finance>(managedContext)
        ..where((x) => x.user!.id).equalTo(userId)
        ..where((x) => x.id).equalTo(id)
        ..join(object: (x) => x.category);

      final note = await qGetFinance.fetchOne();
      if (note == null) {
        return AppResponse.badRequest(message: 'Не найдено финансовых сводок');
      }
      note.removePropertyFromBackingMap('user');

      var response =
          AppResponse.ok(body: note, message: 'Найдена финансовая сводка');
      return response;
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

//редактирование
  @Operation.put('id')
  Future<Response> updateFinance(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('id') int id,
      @Bind.body() Finance bodyFinance) async {
    try {
      final userId = AppUtils.getIdFromHeader(header);
      final fim = await managedContext.fetchObjectWithID<Finance>(id);
      if (fim == null) {
        return AppResponse.ok(message: 'Финансы не найдены');
      }
      if (fim.user?.id != userId) {
        return AppResponse.ok(message: 'Нельзя редактировать не вашу справку');
      }
if(fim.logicalDel == 0){
      final qUpdateFinance = Query<Finance>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.description = bodyFinance.description ?? fim.description
        ..values.operationName = bodyFinance.operationName ?? fim.operationName
        ..values.operationNumber = bodyFinance.operationNumber ?? fim.operationNumber
        ..values.operationDate =  DateTime.now()
        ..values.transactionAmount = bodyFinance.transactionAmount ?? fim.transactionAmount;

      final qCreateHistory = Query<History>(managedContext)
        ..values.action = "UPDATE"
        ..values.date = DateTime.now()
        ..values.finance!.id = fim.id;  

      qCreateHistory.insert();
      await qUpdateFinance.update();
}
else {return AppResponse.ok(message: 'Данная сводка удалена');}
      return AppResponse.ok(message: 'Финансовая сводка успешно обновлена');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  //логическое удаление
  @Operation.post("id")
  Future<Response> logFinance(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('id') int id,
      @Bind.query('action') int action) async {
    try {
      final userId = AppUtils.getIdFromHeader(header);
      final fim = await managedContext.fetchObjectWithID<Finance>(id);
      if (fim == null) {
        return AppResponse.ok(message: 'Финансы не найдены');
      }
      if (fim.user?.id != userId) {
        return AppResponse.ok(message: 'Нельзя редактировать не вашу справку');
      }
      if (action == 0 || action == 1) {
        final qlogFinance = Query<Finance>(managedContext)
          ..where((x) => x.id).equalTo(id)
          ..values.logicalDel = action;
        await qlogFinance.update();
      }
       if (action == 0 ) {
        return AppResponse.ok(message: 'Данная финансовая сводка восстановлена');
       }
       else if (action == 1 ) {
        final qCreateHistory = Query<History>(managedContext)
        ..values.action = "LOGDEL"
        ..values.date = DateTime.now()
        ..values.finance!.id = fim.id;  

        qCreateHistory.insert();
        return AppResponse.ok(message: 'Данная финансовая сводка удалена');
       }
      else {  return AppResponse.ok(message: 'Данная функция пока не доступна');
  }
      
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

//удаление
  @Operation.delete('id')
  Future<Response> deleteFinance(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('id') int id) async {
    try {
      final userId = AppUtils.getIdFromHeader(header);
      final user = await managedContext.fetchObjectWithID<User>(userId);
      if (user == null) {
        throw AppResponse.badRequest(message: 'Невалидный токен');
      }

      final finance = await managedContext.fetchObjectWithID<Finance>(id);
      if (finance == null) {
        return AppResponse.badRequest(message: 'Не найдено финансовых сводок');
      }

      if (finance.user!.id != userId) {
        final data = {'user': finance.user!.id, 'user': userId};
        return AppResponse.badRequest(
            message: 'Данную сводку не возможно удалить данным юзером');
      }

      final qDeleteFinance = Query<Finance>(managedContext)
        ..where((x) => x.id).equalTo(id);


      final qCreateHistory = Query<History>(managedContext)
        ..values.action = "DELETE"
        ..values.date = DateTime.now()
        ..values.finance!.id = finance.id;  

        qCreateHistory.insert();

        await qDeleteFinance.delete();

      return AppResponse.ok(message: 'Сводка была успешно удалена');
    } catch (e) {
      return AppResponse.serverError(e,
          message: 'Ошибка удаления финансовой сводки');
    }
  }

  //Пагинация
  @Operation.get()
  Future<Response> getAllFinance(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      {@Bind.query('str') String str = '',
      @Bind.query('pageLimit') int pageLimit = 20,
      @Bind.query('skipRows') int skipRows = 0}) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final qGetFinance = Query<Finance>(managedContext)
        ..fetchLimit = pageLimit
        ..offset = pageLimit * skipRows
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.logicalDel).equalTo(0)
        ..where((x) => x.operationName).contains(str, caseSensitive: false)
        ..join(object: (x) => x.user)
        ..join(object: (x) => x.category);
      final List<Finance> finances = await qGetFinance.fetch();
      if (finances.isEmpty) {
        return AppResponse.ok(message: 'Не найдено финансовых справок');
      }

      for (var finance in finances) {

        finance.removePropertyFromBackingMap('user');
      }

      return AppResponse.ok(
          body: finances,
          message: 'Финансовые справки, созданные данным пользователем');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}