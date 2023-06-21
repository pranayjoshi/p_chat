import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/common/widgets/loader.dart';
import 'package:p_chat/apps/auth/controller/auth_controller.dart';
// import 'package:p_chat/apps/call/controller/call_controller.dart';
// import 'package:p_chat/apps/call/screens/call_pickup_screen.dart';
import 'package:p_chat/apps/chat/widgets/chat_field.dart';
import 'package:p_chat/models/user.dart';
import 'package:p_chat/apps/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  // final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    // required this.isGroupChat,
    // required this.profilePic,
  }) : super(key: key);

  // void makeCall(WidgetRef ref, BuildContext context) {
  //   ref.read(callControllerProvider).makeCall(
  //         context,
  //         name,
  //         uid,
  //         profilePic,
  //         isGroupChat,
  //       );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
        // title: isGroupChat
        //     ? Text(name)
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Row(
                children: [
                  CircleAvatar(foregroundImage: NetworkImage(profilePic),),
                  Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(color: textColor),
                      ),
                      Text(
                        snapshot.data!.isOnline ? 'online' : 'offline',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: textColor),
                      ),
                    ],
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => {},
            color: textColor,
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            color: textColor,
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            color: textColor,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: false,
            ),
          ),
          ChatField(
            recieverUserId: uid,
            isGroupChat: false,
          ),
        ],
      ),
    );
  }
}
