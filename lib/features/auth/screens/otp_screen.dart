import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerStatefulWidget {
  static const String routeName = "otp_screen";
  final String verificationId;

  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  bool isLoading = false;

  void verifyOTP({
    required WidgetRef ref,
    required BuildContext context,
    required String userOTP,
  }) {
    setState(() {
      isLoading = true;
    });
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: widget.verificationId,
          userOTP: userOTP,
        );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying your number"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const Text("We have sent an SMS with a code."),
            SizedBox(
              width: size.width / 2,
              child: TextFormField(
                textAlign: TextAlign.center,
                maxLength: 6,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(
                      ref: ref,
                      context: context,
                      userOTP: value.trim(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
