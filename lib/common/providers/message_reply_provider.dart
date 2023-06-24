import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final String name;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.name, this.isMe, this.messageEnum);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);