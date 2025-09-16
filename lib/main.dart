import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/router/app_router.dart';
import 'package:note_app/core/theme/theme_data.dart';
import 'package:note_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_app/injection_container.dart' as di;
import 'package:note_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initial();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
      child: MaterialApp.router(
        title: "Note App",
        debugShowCheckedModeBanner: false,
        theme: themeData,
        routerConfig: AppRouter().routerConfig,
      ),
    );
  }
}
