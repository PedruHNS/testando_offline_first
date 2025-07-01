import 'package:get_it/get_it.dart';
import 'package:teste_offline_first/UI/page/shopping_list/shopping_list_controller.dart';
import 'package:teste_offline_first/repositories/local_storage_sqflite.dart';
import 'package:teste_offline_first/services/firebase_firestore_service.dart';

class Setup {
  static void init() {
    final getIt = GetIt.instance;

    getIt.registerSingleton(LocalStorageRepository());

    getIt.registerLazySingleton<ShoppingListController>(
      () => ShoppingListController(
        local: getIt<LocalStorageRepository>(),
        firestore: FirebaseFirestoreService(getIt<LocalStorageRepository>()),
      ),
      dispose: (param) => param.dispose(),
    );
  }
}
