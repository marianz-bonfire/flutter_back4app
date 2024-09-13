import 'package:flutter/material.dart';
import 'package:flutter_back4app/core/common/app_routes.dart';
import 'package:flutter_back4app/ui/pages.dart';
import 'package:flutter_back4app/core/common/app_preference.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'core/navigator_context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'YOUR_APP_ID_HERE';
  const keyClientKey = 'YOUR_CLIENT_KEY_HERE';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  await AppPreference.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorContext.key,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: AppRoutes.routes,
    );
  }
}
