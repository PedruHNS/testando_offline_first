import 'dart:developer';

abstract class BaseController {
  BaseController() {
    onInit();
  }

  void onInit() {
    log('$runtimeType onInit chamado.');
  }

  void dispose() {
    log(' $runtimeType dispose chamado.');
  }
}
