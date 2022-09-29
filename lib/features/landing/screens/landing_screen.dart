import 'package:flutter/material.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/widgets/custom_button.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              // SizedBox(height: size.height / 15, width: double.infinity),
              const Spacer(flex: 2),
              const Text(
                "Welcome to WhatsApp",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 2),
              // SizedBox(height: size.height / 11),
              Image.asset(
                "assets/bg.png",
                color: tabColor,
              ),
              const Spacer(flex: 2),
              // SizedBox(height: size.height / 11),
              const Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              // const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                text: "AGREE AND CONTINUE",
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
