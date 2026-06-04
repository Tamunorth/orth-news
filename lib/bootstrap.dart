import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:orth_news/app/view/app.dart';
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('onError(${bloc.runtimeType}, $error)');
    }
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );
  Bloc.observer = const AppBlocObserver();

  runApp(const OrthNewsApp());
}
