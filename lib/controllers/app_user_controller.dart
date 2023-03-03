import 'dart:io';
import 'dart:math';

import 'package:conduit/conduit.dart';
import 'package:dart_conduit/model/user.dart';
import 'package:dart_conduit/utils/app_response.dart';
import 'package:dart_conduit/utils/app_utils.dart';

class AppUserController extends ResourceController {
  AppUserController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getProfile(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализовать для просмотра функции нажмите на картинку
      final id = AppUtils.getIdFromHeader(header);
      // Получаем данные пользователя по его id
      final user = await managedContext.fetchObjectWithID<User>(id);
      // Удаляем не нужные параметры для красивого вывода данных пользователя
      user!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Успешное получение профиля', body: user.backing.contents
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения профиля');
    }
  }

  @Operation.post()
  Future<Response> updateProfile(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() User user,
  ) async {
    try {
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализовать для просмотра функции нажмите на картинку
      final id = AppUtils.getIdFromHeader(header);
      // Получаем данные пользователя по его id
      final fUser = await managedContext.fetchObjectWithID<User>(id);
      // Запрос для обновления данных пользователя
      final qUpdateUser = Query<User>(managedContext)
      ..where((element) => element.id)
      .equalTo(id)
      ..values.userName = user.userName ?? fUser!.userName
      ..values.email = user.email ?? fUser!.email;
      await qUpdateUser.updateOne();
      // Вызов функции для обновления данных пользователя
      final findUser = await managedContext.fetchObjectWithID<User>(id);
      // Удаляем не нужные параметры для красивого вывода данных пользователя
      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);
      return AppResponse.ok(
        message: 'Успешное обновление данных', body: findUser.backing.contents
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления данных');
    }
  }

  @Operation.put()
  Future<Response> updatePassword (
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.query('newPassword') String newPassword,
    @Bind.query('oldPassword') String oldPassword,
  ) async {
    try {
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализовать для просмотра функции нажмите на картинку
      final id = AppUtils.getIdFromHeader(header);
      // Запрос для обновления данных пользователя
      final qFindUser = Query<User>(managedContext)
      ..where((element) => element.id).equalTo(id)
      ..returningProperties((element) => [element.salt, element.hashPassword],);

      final fUser = await qFindUser.fetchOne();

      final oldHashPassword = generatePasswordHash(oldPassword, fUser!.salt ?? "");

      if (oldHashPassword != fUser.hashPassword) {
        return AppResponse.badRequest(message: 'Неверный старый пароль',);
      }

      final newHashPassword = generatePasswordHash(newPassword, fUser.salt ?? "");

      final qUpdateUser = Query<User>(managedContext)
      ..where((x) => x.id).equalTo(id)
      ..values.hashPassword = newHashPassword;

      await qUpdateUser.fetchOne();

      return AppResponse.ok(body: 'Пароль успешно обновлен');  
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления пароля');
    }
  }
}