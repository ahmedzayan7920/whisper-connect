import 'dart:io';

import 'package:chat_app/common/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:chat_app/features/auth/screens/otp_screen.dart';
import 'package:chat_app/features/auth/screens/user_information_screen.dart';
import 'package:chat_app/features/group/screens/create_group_screen.dart';
import 'package:chat_app/features/home/screens/search_screen.dart';
import 'package:chat_app/features/select_contact/screens/select_contacts_screen.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:chat_app/features/settings/screens/profile_screen.dart';
import 'package:chat_app/features/settings/screens/settings_screen.dart';
import 'package:chat_app/features/status/screens/confirm_status_screen.dart';
import 'package:chat_app/features/status/screens/status_screen.dart';
import 'package:chat_app/model/status_model.dart';
import 'package:chat_app/model/user_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      var arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) =>
            MobileChatScreen(
              name: arguments["name"],
              uid: arguments["uid"],
              profilePicture: arguments["profilePicture"],
              isGroupChat: arguments["isGroupChat"],
            ),
      );

    case ConfirmStatusScreen.routeName:
      File image = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(image: image),
      );

    case StatusScreen.routeName:
      StatusModel status = settings.arguments as StatusModel;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(status: status),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );

    case SettingsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );

    case ProfileScreen.routeName:
      UserModel user = settings.arguments as UserModel;
      return MaterialPageRoute(
        builder: (context) =>  ProfileScreen(user: user),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorHandel(error: "No Screen Found"),
      );
  }
}
