import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/config/variables/strings/auth_strings.dart';
import 'package:ai_coach/core/extensions/sizes.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    //auth dan geliyorsa streamden önceki state erişip tekrardan kontrol etmeme eklenebilir
    if (BlocProvider.of<UserBlocBloc>(context).state is IsAuthenticatedDone ||
        BlocProvider.of<UserBlocBloc>(context).state
            is IsAuthenticatedLoading) {
    } else {
      BlocProvider.of<UserBlocBloc>(context).add(const GetCurrentUserRequest());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBlocBloc, UserBlocState>(
        listenWhen: (previous, current) {
          if (previous is IsAuthenticatedDone &&
              current is IsAuthenticatedLoading) {
            return false;
          } else {
            return true;
          }
        },
        buildWhen: (previous, current) {
          if (previous is IsAuthenticatedDone &&
                  current is IsAuthenticatedLoading ||
              current is IsAuthenticatedDone) {
            return false;
          } else {
            return true;
          }
        },
        listener: (context, state) {
          BuildContext dialogContext = context;
          switch (state) {
            case UserBlocLogout():
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/auth", (ModalRoute.withName("/auth")));
              break;
            case IsAuthenticatedLoading():
              showDialog(
                context: dialogContext,
                builder: (dialogContext) {
                  return const LoadingDialog();
                },
              );
              break;
            case IsAuthenticatedError():
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              Navigator.of(dialogContext).pushReplacementNamed("/auth");
              break;
            case IsAuthenticatedDone():
              if (dialogContext.mounted) {
                Navigator.of(dialogContext)
                    .popUntil(ModalRoute.withName("/main"));
              }
              break;
          }
        },
        builder: (context, state) {
          return Container(
            color: MainColors.backgroundColor1,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              MainColors.backgroundColor2),
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          fixedSize:
                              WidgetStateProperty.all(const Size(420, 260))),
                      child: Text(
                        "BİLGİLERİNİZİ DOLDURUN",
                        style: CustomTextStyles.mainTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/question");
                      },
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  MainColors.backgroundColor2),
                              shape: WidgetStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              fixedSize: WidgetStateProperty.all(
                                  const Size(420, 260))),
                          child: Text(
                            "AI İLE PROGRAMI OlUŞTUR",
                            style: CustomTextStyles.mainTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed("/ai");
                          },
                        ),
                        const SizedBox(width: 100),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  MainColors.backgroundColor2),
                              shape: WidgetStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              fixedSize: WidgetStateProperty.all(
                                  const Size(420, 260))),
                          child: Text(
                            "PROGRAMI  İLE GÖR",
                            style: CustomTextStyles.mainTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
                Positioned(
                  left: 0,
                  top: -10,
                  child: SizedBox(
                    width: IconSizes.mainIconWidth,
                    height: IconSizes.mainIconWidth,
                    child: Image.asset(AuthStrings.logoUrl),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    style: ButtonStyle(
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(15)),
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                    color: Colors.white,
                    icon: const Row(
                      children: [
                        Icon(FontAwesomeIcons.arrowRightFromBracket),
                        SizedBox(width: 10),
                        Text(
                          "ÇIKIŞ YAP",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    onPressed: () {
                      BlocProvider.of<UserBlocBloc>(context)
                          .add(const LogoutRequest());
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
