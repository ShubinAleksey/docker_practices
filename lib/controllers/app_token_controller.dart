import 'dart:async';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_conduit/utils/app_response.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppTokenController extends Controller {
  @override
  FutureOr<RequestOrResponse?> handle(Request request) {
    try {
      // Получаем токен из header запроса
      final header = request.raw.headers.value(HttpHeaders.authorizationHeader);
      // Из header получаем token
      final token = const AuthorizationBearerParser().parse(header);

      // Получаем jwtClaim для проверки токен
      final jwtClaim = verifyJwtHS256Signature(token ?? "", "SECRET_KEY");
      // Валидируем наш токен
      jwtClaim.validate();
      return request;
    } on JwtException catch (e) {
      return AppResponse.serverError(e.message);
    }
  }
}