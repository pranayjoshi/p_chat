import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/auth/screens/profile.dart';
import 'package:p_chat/apps/chat/widgets/contact_list.dart';
import 'package:p_chat/apps/status/screens/confirm_status.dart';
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
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            "P-Chat",
            style: TextStyle(color: textColor),
          ),
          actions: [
            // IconButton(
            //     color: textColor,
            //     onPressed: () {
            //       logout();
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(Icons.exit_to_app)),
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
                  // onTap: () => Future(
                  //   () => Navigator.pushNamed(
                  //       context, CreateGroupScreen.routeName),
                  // ),
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
            Center(
              child: ElevatedButton(
                child: Text('Mobile!'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProfileScreen()));
                },
              ),
            ),
            Text('Calls')
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
            
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
            Navigator.pushNamed(context, GlobalContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: tabBarController.index == 0 ? const Icon(
            Icons.comment,
            color: Colors.white,
          ) : const Icon(
            Icons.camera,
            color: Colors.white,
          ),
        ));
  }
}
