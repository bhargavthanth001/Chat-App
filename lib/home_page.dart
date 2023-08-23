import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/chat%20side/chat_page.dart';
import 'package:chat_app/profile_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/chat_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    DBHelper.selfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const Icon(
          CupertinoIcons.line_horizontal_3,
          color: Colors.black,
        ),
        title: const Center(
            child: Text(
          'Flutter Chat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileViewPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<List<ChatUser>>(
          stream: DBHelper.getAllUsers(),
          builder: (context, snapshot) {
            debugPrint(snapshot.data.toString());
            if (snapshot.hasData) {
              final responseData = snapshot.data!;
              debugPrint(responseData.toString());
              return ListView.builder(
                itemCount: responseData.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 234, 248, 255),
                    child: ListTile(
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            responseData[index].image,
                          ),
                        ),
                      ),
                      title: Text(responseData[index].name),
                      subtitle: Text(responseData[index].about),
                      onTap: () {
                        debugPrint(responseData[index].id);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              user: responseData[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
