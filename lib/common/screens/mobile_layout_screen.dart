// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/auth/screens/profile.dart';
import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/apps/chat/widgets/contact_list.dart';
import 'package:p_chat/apps/group/screens/create_group_screen.dart';
import 'package:p_chat/apps/status/screens/confirm_status.dart';
import 'package:p_chat/apps/status/screens/status_contacts.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/common/utils/utils.dart';
import 'package:p_chat/apps/auth/controller/auth_controller.dart';
// import 'package:whatsapp_ui/features/group/screens/create_group_screen.dart';
import 'package:p_chat/apps/global_contacts/screens/global_contacts.dart';
// import 'package:p/features/chat/widgets/contacts_list.dart';
// import 'package:whatsapp_ui/features/status/screens/confirm_status_screen.dart';
// import 'package:whatsapp_ui/features/status/screens/status_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {

  final firestore = FirebaseFirestore.instance;
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _firstITR() async {
    await firestore.collection("test").doc("s").set({"dddd":"hi"});
    // var exists = await firestore.collection("test").where("dddd", isEqualTo: "hello").get();
    // print(exists.size);
    // if (exists.size >0) {print("hidawd");}
    // else print("wdwad");
  }

  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    tabBarController.addListener(_handleTabChange);
    WidgetsBinding.instance.addObserver(this);
    // _firstITR();
  }
  void _handleTabChange(){
  setState((){});    
}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // var icon = "comment";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            "P-Chat",
            style: TextStyle(color: textColor),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              color: backgroundColor,
              icon: const Icon(
                Icons.more_vert,
                color: textColor,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Profile',
                    style: TextStyle(color: textColor),
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(context, ProfileScreen.routeName),
                  ),
                ),
                PopupMenuItem(
                  child: const Text(
                    'Create Group',
                    style: TextStyle(color: textColor),
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                        context, CreateGroupScreen.routeName),
                  ),
                ),
                PopupMenuItem(
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: textColor),
                  ),
                  onTap: () {
                    logout();
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: [
            ContactsList(),
            StatusContactsScreen(),
            Text('Calls')
          ],
        ),
        floatingActionButton:floatingButtons(),);
  }
  Widget floatingButtons(){
    return tabBarController.index == 0 ?
   FloatingActionButton(
          onPressed: () async {
              Navigator.pushNamed(context, GlobalContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child:const Icon(
                  Icons.comment,
                  color: Colors.white,
                )
        )
        : FloatingActionButton(
          onPressed: () async {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            // }
          },
          backgroundColor: tabColor,
          child:const Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
        );
  }
}
