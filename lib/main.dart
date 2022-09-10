import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/date_cubit.dart';
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/authentication_screen.dart';
import 'package:mynotify/presentation/screens/home_screen.dart';
import 'package:mynotify/presentation/screens/user_profile_screen.dart';
import 'package:mynotify/presentation/screens/welcome_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes/app_routes.dart';

void main() async {
  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => HydratedBlocOverrides.runZoned(
      () => runApp(const MyApp()),
      storage: storage,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //route instance
  final AppRoutes _appRoutes = AppRoutes();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (_) => DateCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Raleway',
        ),
        // onGenerateRoute: _appRoutes.onGenerateRoute,
        home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state.isNew) {
              return const WelcomeScreen();
            } else {
              return const HomeScreen();
            }
          },
        ),
        routes: {
          '/auth': (_) => const AuthenticationScreen(),
          '/home': (_) => const HomeScreen(),
          '/add-event': (_) => const AddEventScreen(),
          '/user': (_) => const UserProfileScreen(),
        },
      ),
    );
  }

  @override
  void dispose() {
    print('disposing page');
    super.dispose();
  }
}
