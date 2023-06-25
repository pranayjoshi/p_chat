import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/chat/widgets/photo_viewer.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/common/widgets/loader.dart';
import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/apps/chat/screens/mobile_chat_screen.dart';
import 'package:p_chat/models/chat_contact.dart';
import 'package:p_chat/models/group.dart';
// import 'package:p_chat/models/group.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DUMMY
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Group>>(
                stream: ref.watch(chatControllerProvider).chatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  if ( !snapshot.hasData) {
                    return Loader();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'isGroupChat': true,
                                  'profilePic': groupData.groupPic,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  groupData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    groupData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    groupData.groupPic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(groupData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
            StreamBuilder<List<ChatContact>>(
                stream: ref.watch(chatControllerProvider).chatContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  if (!snapshot.hasData) {
                    return Loader();
                  }

                  return Container(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var chatContactData = snapshot.data![index];

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  MobileChatScreen.routeName,
                                  arguments: {
                                    'name': chatContactData.name,
                                    'uid': chatContactData.contactId,
                                    'profilePic': chatContactData.profilePic,
                                    'isGroupChat': false,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: GestureDetector(
                                    onTap: () =>{ Navigator.pushNamed(
                                        context, PhotoViewer.routeName,
                                        arguments: {
                                          "imageUrl": chatContactData.profilePic
                                        })},
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        chatContactData.profilePic,
                                      ),
                                      radius: 30,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StreamBuilder<dynamic>(
                                          stream: ref
                                              .read(chatControllerProvider)
                                              .getUnreadCount(context,
                                                  chatContactData.contactId),
                                          builder: (context, snapshot) {
                                            return snapshot.data != null ?  snapshot.data!.length !=0 ? CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                  snapshot.data.length.toString(),
                                                
                                                  style: const TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 13,
                                                                                    ),
                                                  ),
                                            ): 
                                            Container():Container();
                                                
                                          }),
                                      SizedBox(width: 5,),
                                      Text(
                                        DateFormat.Hm()
                                            .format(chatContactData.timeSent),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
