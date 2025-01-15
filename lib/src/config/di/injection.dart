import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final locator = GetIt.instance;

//Define environments here
const production = Environment("production");
const development = Environment("development");

@InjectableInit(
  initializerName: "init",
  preferRelativeImports: true,
  asExtension: true,
)

Future<GetIt> configureDependencies({
  Environment environment = development,
}) async =>
    locator.init(environment: environment.name);
