import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = "/confirm_status_screen";
  final File image;

  const ConfirmStatusScreen({Key? key, required this.image}) : super(key: key);

  void addStatus({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ref.read(statusControllerProvider).uploadStatus(
          context: context,
          statusImage: image,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Status"),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(image),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(context: context, ref: ref),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
