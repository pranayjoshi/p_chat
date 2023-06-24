import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/status/repository/status_repository.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:story_view/story_view.dart';
import 'package:p_chat/common/widgets/loader.dart';

import 'package:p_chat/models/status.dart';

class StatusScreen extends ConsumerStatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
    // print(widget.status);
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrl[i],
        controller: controller,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.status. &&
    //               widget.status.uid ==
    //                   FirebaseAuth.instance.currentUser!.uid) {
    //             ref.read(statusRepositoryProvider).setChatMessageSeen(
    //                   context,
    //                   widget.recieverUserId,
    //                   messageData.messageId,
    //                 );
    //           }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Status",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}