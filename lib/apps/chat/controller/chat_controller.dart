import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/controller/auth_controller.dart';
import 'package:p_chat/apps/chat/repository/chat_repository.dart';
import 'package:p_chat/common/enums/message_enum.dart';
import 'package:p_chat/common/providers/message_reply_provider.dart';
import 'package:p_chat/models/chat_contact.dart';
import 'package:p_chat/models/group.dart';
import 'package:p_chat/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

    void deleteMessage(
    BuildContext context,
    String recieverUserId,
    String messageId
  ) async{
       ref.read(chatRepositoryProvider).deleteMessage(
    context,
    recieverUserId,
    messageId
  );
}

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) {
    
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  // void sendGIFMessage(
  //   BuildContext context,
  //   String gifUrl,
  //   String recieverUserId,
  //   bool isGroupChat,
  // ) {
  //   final messageReply = ref.read(messageReplyProvider);
  //   int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
  //   String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
  //   String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

  //   ref.read(userDataAuthProvider).whenData(
  //         (value) => chatRepository.sendGIFMessage(
  //           context: context,
  //           gifUrl: newgifUrl,
  //           recieverUserId: recieverUserId,
  //           senderUser: value!,
  //           messageReply: messageReply,
  //           isGroupChat: isGroupChat,
  //         ),
  //       );
    // ref.read(messageReplyProvider.state).update((state) => null);
  // }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
  
  Stream<dynamic> getUnreadCount(
    BuildContext context,
    String recieverUserId,
  ) {
      return chatRepository.getUnreadCount(
      context,
      recieverUserId
    );
    }
}

  
