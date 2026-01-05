import 'package:get_it/get_it.dart';
import 'package:todo/repositories/daily_repository.dart';
import 'package:todo/repositories/star_repository.dart';
import 'package:todo/repositories/todo_repository.dart';

// GetIt 인스턴스 생성
final GetIt locator = GetIt.instance;

void setupLocator() {
  // Repository들을 등록합니다.
  // registerLazySingleton: 해당 타입이 처음 요청될 때 인스턴스를 생성합니다. (앱 전체에서 하나의 인스턴스만 사용)
  locator.registerLazySingleton(() => DailyRepository());
  locator.registerLazySingleton(() => TodoRepository(locator<DailyRepository>()));
  locator.registerLazySingleton(() => StarRepository());
}