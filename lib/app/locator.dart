import 'package:didyoucodetoday/app/environment.dart';
import 'package:didyoucodetoday/controllers/auth_controller.dart';
import 'package:didyoucodetoday/controllers/user_data_controller.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

AuthController auth() => locator.get<AuthController>();
Environment env() => locator.get<Environment>();
UserDataController userData() => locator.get<UserDataController>();

void setupLocator({
  required Environment environment,
}) {
  locator.registerSingleton<Environment>(environment);
  locator.registerLazySingleton<AuthController>(() => AuthController());
  locator.registerLazySingleton<UserDataController>(() => UserDataController());
}
