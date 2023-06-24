import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/common/enums/message_enum.dart';
import 'package:p_chat/common/enums/message_enum.dart';
import 'package:p_chat/common/providers/message_reply_provider.dart';
// import 'package:p_chat/common/providers/message_reply_provider.dart';
import 'package:p_chat/common/widgets/loader.dart';

import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/apps/chat/widgets/message_cards/my_message_card.dart';
import 'package:p_chat/apps/chat/widgets/message_cards/sender_message_card.dart';
import 'package:p_chat/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  bool _needsScroll = true;

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // messageController
    //             .jumpTo(messageController.position.maxScrollExtent+60);
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  void _scrollToEnd(){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(messageController.hasClients){
                  messageController.jumpTo(messageController.position.maxScrollExtent+60);
          }
    });
  }

  @override
  Widget build(BuildContext context) {
  //   if (_needsScroll) {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => _scrollToEnd());
  //   _needsScroll = false;
  // }
    return StreamBuilder<List<Message>>(
        stream: 
        widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .groupChatStream(widget.recieverUserId)
            : 
            ref
                .read(chatControllerProvider)
                .chatStream(widget.recieverUserId),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          // if ( !snapshot.hasData) {
          //           return Loader();
          //         }
          

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.minScrollExtent);
          });

          return ListView.builder(
            reverse: true,
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen &&
                  messageData.recieverid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.recieverUserId,
                      messageData.messageId,
                    );
              }
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  isGroupChat: widget.isGroupChat,
                  date: timeSent,
                  senderName: messageData.senderName,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                    messageData.text,
                    messageData.senderName,
                    true,
                    messageData.type,
                  ),
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                isGroupChat: widget.isGroupChat,
                date: timeSent,
                type: messageData.type,
                senderName: messageData.senderName,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  messageData.text,
                  messageData.senderName,
                  false,
                  messageData.type,
                ),
                repliedText: messageData.repliedMessage,
              );
            },
          );
        });
  }
}