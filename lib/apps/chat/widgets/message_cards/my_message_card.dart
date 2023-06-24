import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/apps/chat/widgets/display_text_image_gif.dart';
import 'package:p_chat/common/enums/message_enum.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends ConsumerWidget {
  final String messageId;
  final String receiverId;
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final String senderName;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final bool isGroupChat;

  const MyMessageCard({
    Key? key,
    required this.messageId,
    required this.receiverId,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.senderName,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              context: context,
              builder: (BuildContext context) {
                return Container(

                    padding: EdgeInsets.all(5),
                    color: chatBarMessage,
                    child: new Wrap(children: <Widget>[
                      new ListTile(
                        leading: new Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: new Text(
                          'Delete',
                          style: TextStyle(color: textColor),
                        ),
                        onTap: () => {
                          ref.read(chatControllerProvider).deleteMessage(context, receiverId, messageId),
                          Navigator.pop(context)
                        },
                      )
                    ]));
              });
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: mainColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      children: [
                        Text(
                          
                          textAlign: TextAlign.left,
                          senderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            backgroundColor: textColor,
                          ),
                        ),
                        SizedBox(height: 3),
                        if (isReplying)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),
                            child: Column(children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                child: DisplayTextImageGIF(
                                  message: repliedText,
                                  type: repliedMessageType,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ]),
                          ),
                        // if (isGroupChat && !isReplying)
                        //   Column(
                        //     children: [
                        //       Text(
                        //         senderName,
                        //         style: const TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 3,
                        //       ),
                        //     ],
                        //   ),
                        Container(
                          padding: message.length < 3
                              ? EdgeInsets.only(left: 20)
                              : EdgeInsets.only(left: 5),
                          child: DisplayTextImageGIF(
                            message: message,
                            type: type,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 20,
                          color: isSeen ? Colors.blue : Colors.white60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
