import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/paddings/main_paddings.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/core/extensions/sizes.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoginPage = true;

  @override
  void initState() {
    BlocProvider.of<UserBlocBloc>(context).add(const GetCurrentUserRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = context.getWidth();
    double screenHeight = context.getHeigth();
    return Scaffold(
      body:
          BlocConsumer<UserBlocBloc, UserBlocState>(listener: (context, state) {
        BuildContext dialogContext = context;
        switch (state) {
          //Checking first if user already authenticated. If so navigate.
          case IsAuthenticatedLoading():
            showDialog(
              context: context,
              builder: (context) {
                dialogContext = context;
                return const LoadingDialog();
              },
            );
            break;
          case IsAuthenticatedDone():
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
            Navigator.of(context).pushReplacementNamed("/main");
            break;
          case IsAuthenticatedError():
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          //User Login-Register Request
          case UserBlocLoading():
            showDialog(
              context: context,
              builder: (context) {
                dialogContext = context;
                return const LoadingDialog();
              },
            );
            break;
          case UserBlocDone():
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
            Navigator.of(context).pushReplacementNamed("/main");
            break;
          case UserBlocError():
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Failed"),
                  content: Text(state.error!),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    )
                  ],
                );
              },
            );
            break;
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(gradient: SideColors.authGradient),
                child: Padding(
                  padding: MainPaddings.padding3,
                  child: Column(
                    children: [
                      Container(
                        width: IconSizes.authIconSize,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90))),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
