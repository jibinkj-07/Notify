import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notify/logic/cubit/authentication_cubit.dart';
import 'package:notify/logic/cubit/cloud_sync_cubit.dart';
import 'package:notify/logic/cubit/date_cubit.dart';
import 'package:notify/logic/cubit/event_file_handler_cubit.dart';
import 'package:notify/logic/services/event_data_services.dart';
import 'package:notify/presentation/screens/home/calender_screen.dart';
import 'package:notify/presentation/widgets/calendar/calendar_message_screen.dart';
import 'package:notify/presentation/screens/home/add_event_screen.dart';
import 'package:notify/presentation/screens/home/home_screen.dart';
import 'package:notify/presentation/screens/onboarding/auth_screen.dart';
import 'package:notify/presentation/screens/onboarding/forgot_password_screen.dart';
import 'package:notify/presentation/screens/onboarding/login_screen.dart';
import 'package:notify/presentation/screens/onboarding/signup_screen.dart';
import 'package:notify/presentation/screens/onboarding/welcome_screen.dart';
import 'package:notify/util/custom_page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'logic/cubit/internet_cubit.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Step 2
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
      () {
        runApp(MyApp(
          connectivity: Connectivity(),
        ));
        // whenever your initialization is completed, remove the splash screen:
        FlutterNativeSplash.remove();
      },
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
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          // onGenerateRoute: _appRoutes.onGenerateRoute,
          home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              // log('state of auth cubit isnew is ${state.isNew}');
              if (state.isNew) {
                return const WelcomeScreen();
              } else {
                return const HomeScreen();
              }
            },
          ),
          // home: const LoginScreen(),
          routes: {
            '/authentication': (_) => const AuthScreen(),
            '/signup': (_) => const SignUpScreen(),
            '/login': (_) => const LoginScreen(),
            '/forgot-pw': (_) => const ForgotPasswordScreen(),
            '/home': (_) => const HomeScreen(),
            '/add-event': (_) => const AddEventScreen(),
            '/calendar': (_) => const CalenderScreen(),
            // '/user-sync': (_) => const UserCloudEventSync(),
            '/calendar-message': (_) => const CalendarMessageScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
