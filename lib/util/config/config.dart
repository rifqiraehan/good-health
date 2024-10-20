export 'config_stub.dart'
    if (dart.library.io) 'config_mobile.dart'
    if (dart.library.html) 'config_web.dart';