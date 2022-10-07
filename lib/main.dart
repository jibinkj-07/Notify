import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/cloud_sync_cubit.dart';
import 'package:mynotify/logic/cubit/date_cubit.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/authentication_screen.dart';
import 'package:mynotify/presentation/screens/home_screen.dart';
import 'package:mynotify/presentation/screens/user_profile_screen.dart';
import 'package:mynotify/presentation/screens/welcome_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'logic/cubit/internet_cubit.dart';
import 'models/event_list_model.dart';
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
      () => runApp(MyApp(
        connectivity: Connectivity(),
      )),
      storage: storage,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  const MyApp({Key? key, required this.connectivity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //cubit for authentication feature
        BlocProvider(
          create: (_) => AuthenticationCubit(),
        ),
        //cubit for calender feature
        BlocProvider(
          create: (_) => DateCubit(),
        ),
        //cubit for internet connectivity feature
        BlocProvider(
          create: (_) => InternetCubit(connectivity: connectivity),
        ),
        //  //bloc for eventlist connectivity feature
        BlocProvider(
          create: (_) => EventFileHandlerCubit(),
        ),
        BlocProvider(
          create: (_) => CloudSyncCubit(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => EventDataServices(),
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
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
