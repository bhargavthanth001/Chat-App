import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/google_sign_in.dart';
import 'package:chat_app/login_screen.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/material.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({Key? key}) : super(key: key);

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: StreamBuilder<ChatUser>(
        stream: DBHelper.getSingleUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!.image,
                        ),
                        fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(snapshot.data!.name),
                  trailing: IconButton(
                    onPressed: () {
                      _updateName(snapshot.data!.name);
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(snapshot.data!.about),
                  trailing: IconButton(
                    onPressed: () {
                      _updateAbout(snapshot.data!.about);
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.mark_email_unread_outlined),
                  title: Text(snapshot.data!.email),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.red.shade100,
                  child: ListTile(
                    onTap: _logoutDialog,
                    leading: const Icon(
                      Icons.output_outlined,
                      color: Colors.red,
                    ),
                    title: const Text("Logout"),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _logoutDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout ?"),
          content: const Text("Do you want to logout from this device ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SignIn.signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  _updateName(String name) {
    final updateControl = TextEditingController();
    updateControl.text = name;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              controller: updateControl,
              decoration: InputDecoration(hintText: updateControl.text),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String updatedName = updateControl.text;
                  DBHelper.updateName(updatedName);
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  _updateAbout(String about) {
    final updateControl = TextEditingController();
    updateControl.text = about;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              controller: updateControl,
              decoration: InputDecoration(hintText: updateControl.text),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String updatedAbout = updateControl.text;
                  DBHelper.updateAbout(updatedAbout);
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }
}
