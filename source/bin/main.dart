import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_conduit/dart_conduit.dart';

void main() async {
  // Указываем порт на котором у нас будет запущен сервис в данном случае API
  final port = int.parse(Platform.environment["PORT"] ?? '9996');
  // Иницилизируем переменную и назначаем порт на котором будет развернут наш сервис
  final service = Application<AppService>()
  ..options.port = port;

  // Запускаем наш сервис. Создаем логирование и указываем что будет запущено 3 изолята
  await service.start(numberOfInstances: 3, consoleLogging: true);
}
