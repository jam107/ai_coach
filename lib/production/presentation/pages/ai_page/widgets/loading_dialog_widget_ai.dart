import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialogAi extends StatelessWidget {
  const LoadingDialogAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.newtonCradle(
      color: Colors.white,
      size: 25,
    ));
  }
}
