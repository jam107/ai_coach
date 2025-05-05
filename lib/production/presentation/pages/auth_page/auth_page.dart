import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/paddings/main_paddings.dart';
import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/config/variables/strings/auth_strings.dart';
import 'package:ai_coach/core/extensions/sizes.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/login_form.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/register_form.dart';
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
      body: BlocConsumer<UserBlocBloc, UserBlocState>(
        listener: (context, state) {
          BuildContext dialogContext = context;
          switch (state) {
            //Checking first if user already authenticated. If so navigate.
            case IsAuthenticatedLoading():
              showDialog(
                context: dialogContext,
                builder: (dialogContext) {
                  return const LoadingDialog();
                },
              );
              break;
            case IsAuthenticatedDone():
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              Navigator.of(context).pushNamed("/main");
              break;
            case IsAuthenticatedError():
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            //User Login-Register Request
            case UserBlocLoading():
              showDialog(
                context: dialogContext,
                builder: (dialogContext) {
                  return const LoadingDialog();
                },
              );
              break;
            case UserBlocDone():
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              Navigator.of(context).pushNamed("/main");
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
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(color: MainColors.backgroundColor1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: IconSizes.authIconWidthSize,
                            height: IconSizes.authIconHeightSize,
                            child: Image.asset(AuthStrings.logoUrl),
                          ),
                          const SizedBox(height: 15),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) {
                              // Hangi widget olduğunu belirlemek için key kullan
                              final isLogin =
                                  child.key == const ValueKey('login');

                              final offsetAnimation = animation.drive(
                                Tween<Offset>(
                                  begin: isLogin
                                      ? const Offset(-4.0, 0.0)
                                      : const Offset(4.0, 0.0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeInOut)),
                              );

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            child: _isLoginPage
                                ? const LoginForm(key: ValueKey('login'))
                                : const RegisterForm(key: ValueKey('register')),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth,
                                constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    minHeight: 56,
                                    maxHeight: 56),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation:
                                            const WidgetStatePropertyAll(10),
                                        shape: WidgetStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                MainColors.buttonColor1)),
                                    onPressed: () {
                                      setState(() {
                                        _isLoginPage = !_isLoginPage;
                                      });
                                    },
                                    child: Text(
                                      _isLoginPage
                                          ? AuthStrings.registerButtonText
                                          : AuthStrings.loginButtonText,
                                      style: CustomTextStyles.primaryStyle,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -25,
                top: -10,
                child: SizedBox(
                  width: IconSizes.authVectorRightWidth,
                  height: IconSizes.authVectorRightHeight,
                  child: Image.asset(AuthStrings.vectorRightUrl),
                ),
              ),
              Positioned(
                left: -95,
                bottom: -85,
                child: SizedBox(
                  width: IconSizes.authElipseLeft1Width,
                  height: IconSizes.authElipseLeft1Height,
                  child: Image.asset(AuthStrings.elipseLeftUrl1),
                ),
              ),
              Positioned(
                left: -240,
                bottom: -225,
                child: SizedBox(
                  width: IconSizes.authElipseLeft2Width,
                  height: IconSizes.authElipseLeft2Height,
                  child: Image.asset(AuthStrings.elipseLeftUrl2),
                ),
              ),
              Positioned(
                left: -190,
                bottom: -260,
                child: SizedBox(
                  width: IconSizes.authElipseLeft3Width,
                  height: IconSizes.authElipseLeft3Height,
                  child: Image.asset(AuthStrings.elipseLeftUrl3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
