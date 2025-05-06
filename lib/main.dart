import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/ai_page/ai_page.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/auth_page.dart';
import 'package:ai_coach/production/presentation/pages/main/main_page.dart';
import 'package:ai_coach/production/presentation/pages/question_page/question_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SemanticsBinding.instance.ensureSemantics();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBlocBloc>(create: (context) => UserBlocBloc()),
        ],
        child: MaterialApp(
          initialRoute: "/auth",
          routes: {
            "/auth": (context) => const AuthPage(),
            "/main": (context) => const MainPage(),
            "/question": (context) => const QuestionPage(),
            "/ai": (context) => const AiPage(),
          },
          debugShowCheckedModeBanner: false,
          title: 'AI MENTOR',
          theme: ThemeData(
            useMaterial3: true,
          ),
        ));
  }
}
