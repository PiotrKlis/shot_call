import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shot_call/common/dependency_injection//get_it.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void initializeDependencyInjection() {
  getIt.init();
}
