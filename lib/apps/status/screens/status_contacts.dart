import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/status/controller/status_controller.dart';
import 'package:p_chat/apps/status/screens/status.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/common/widgets/loader.dart';
import 'package:p_chat/models/status.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // if (!messageData.isSeen &&
    //               messageData.recieverid ==
    //                   FirebaseAuth.instance.currentUser!.uid) {
    //             ref.read(chatControllerProvider).setChatMessageSeen(
    //                   context,
    //                   widget.recieverUserId,
    //                   messageData.messageId,
    //                 );
    //           }
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            print(statusData);
            return Column(
              children: [
                SizedBox(height: 12,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: statusData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}