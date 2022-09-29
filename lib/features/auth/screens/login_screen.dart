import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/common/widgets/custom_button.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  Country? country;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (value) {
        setState(() {
          country = value;
        });
      },
    );
  }

  void sendCode() {
    setState(() {
      isLoading = true;
    });
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
          context: context, phoneNumber: "+${country!.phoneCode}$phoneNumber");
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context: context, content: "Fill out all fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text("WhatsApp will need to verify your phone number."),
            const SizedBox(height: 10),
            TextButton(
              onPressed: pickCountry,
              child: const Text("Pick Country"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (country != null)
                  Text("${country!.flagEmoji} +${country!.phoneCode}"),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "phone number",
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    onPressed: sendCode,
                    text: "NEXT",
                  ),
          ],
        ),
      ),
    );
  }
}
