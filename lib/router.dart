import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/auth/screens/otp_screen.dart';
import 'package:p_chat/apps/auth/screens/user_information_screen.dart';
import 'package:p_chat/apps/group/screens/create_group_screen.dart';
import 'package:p_chat/apps/select_contacts/screens/select_contacts_screen.dart';
import 'package:p_chat/apps/chat/screens/mobile_chat_screen.dart';
import 'package:p_chat/apps/status/screens/confirm_status_screen.dart';
import 'package:p_chat/apps/status/screens/status_screen.dart';
import 'package:whatsapp_ui/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
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
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
