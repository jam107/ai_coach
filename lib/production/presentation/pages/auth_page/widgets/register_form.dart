import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/config/variables/strings/auth_strings.dart';
import 'package:ai_coach/core/extensions/sizes.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameControllerRegister =
      TextEditingController();
  final TextEditingController _passwordControllerRegister =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();
  RegExp get _specialCharRegex => RegExp(r"^[\p{L}\p{N}]+$", unicode: true);
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = context.getWidth();

    return Form(
        key: _registerFormKey,
        child: Column(
          children: [
            TextFormField(
                style: CustomTextStyles.primaryStyle2,
                controller: _emailController,
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return AuthStrings.errorText1;
                    } else if (!EmailValidator.validate(value)) {
                      return AuthStrings.errorText4;
                    }
                  }
                  return null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      minWidth: AuthPageSizes.txtFormFieldWidth,
                      maxWidth: AuthPageSizes.txtFormFieldWidth,
                      maxHeight: AuthPageSizes.txtFormFieldMaxHeight,
                      minHeight: AuthPageSizes.txtFormFieldMinHeight),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintStyle: CustomTextStyles.secondaryStyle,
                  hintText: AuthStrings.txtFormField3Hint,
                  prefixIcon: const Icon(FontAwesomeIcons.envelope),
                  border: const OutlineInputBorder(),
                )),
            SizedBox(height: MarginSizes.loginMargin2),
            TextFormField(
                style: CustomTextStyles.primaryStyle2,
                controller: _usernameControllerRegister,
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return AuthStrings.errorText1;
                    } else if (value.length <= 6) {
                      return AuthStrings.errorText2;
                    } else if (!_specialCharRegex.hasMatch(value)) {
                      return AuthStrings.errorText3;
                    }
                  }
                  return null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      minWidth: AuthPageSizes.txtFormFieldWidth,
                      maxWidth: AuthPageSizes.txtFormFieldWidth,
                      maxHeight: AuthPageSizes.txtFormFieldMaxHeight,
                      minHeight: AuthPageSizes.txtFormFieldMinHeight),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintStyle: CustomTextStyles.secondaryStyle,
                  hintText: AuthStrings.txtFormField1Hint,
                  prefixIcon: const Icon(FontAwesomeIcons.user),
                  border: const OutlineInputBorder(),
                )),
            SizedBox(height: MarginSizes.loginMargin2),
            TextFormField(
                obscureText: _passwordVisible,
                style: CustomTextStyles.primaryStyle2,
                controller: _passwordControllerRegister,
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return AuthStrings.errorText1;
                    } else if (value.length <= 6) {
                      return AuthStrings.errorText2;
                    } else if (!_specialCharRegex.hasMatch(value)) {
                      return AuthStrings.errorText3;
                    }
                  }
                  return null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      minWidth: AuthPageSizes.txtFormFieldWidth,
                      maxWidth: AuthPageSizes.txtFormFieldWidth,
                      maxHeight: AuthPageSizes.txtFormFieldMaxHeight,
                      minHeight: AuthPageSizes.txtFormFieldMinHeight),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintStyle: CustomTextStyles.secondaryStyle,
                  hintText: AuthStrings.txtFormField2Hint,
                  prefixIcon: const Icon(FontAwesomeIcons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: MainColors.secondaryTextColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                )),
            SizedBox(height: MarginSizes.loginMargin3),
            Container(
                width: phoneWidth,
                constraints: const BoxConstraints(
                    maxWidth: 300, minHeight: 56, maxHeight: 56),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: const WidgetStatePropertyAll(10),
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            MainColors.buttonColor1)),
                    onPressed: () {
                      if (_registerFormKey.currentState!.validate()) {
                        UserModel user = UserModel(
                            username: _usernameControllerRegister.text,
                            mail: _emailController.text);
                        BlocProvider.of<UserBlocBloc>(context).add(CreateUser(
                            user: user,
                            password: _passwordControllerRegister.text));
                      }
                    },
                    child: Text(
                      AuthStrings.registerButtonText,
                      style: CustomTextStyles.primaryStyle,
                    ))),
          ],
        ));
  }
}
