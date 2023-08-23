import 'dart:io';
import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/chat%20side/message_card.dart';
import 'package:chat_app/chat%20side/send_image_page.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final ChatUser? user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  bool isEmojiShow = false;
  List<Message> list = [];

  final ScrollController _scrollController = ScrollController();

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      appBar: AppBar(
        title: Text(
          widget.user!.name,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (
              BuildContext context,
            ) {
              return [
                const PopupMenuItem(
                  child: Text("Settings"),
                ),
                const PopupMenuItem(
                  child: Text("Profile"),
                ),
                const PopupMenuItem(
                  child: Text("About"),
                ),
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 60,
            left: 10,
            right: 10,
            child: StreamBuilder<List<Message>>(
                stream: DBHelper.getAllMessage(widget.user!),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final responseData = snapshot.data;
                      list = responseData!;
                      if (list.isNotEmpty) {
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: list.length,
                            padding: const EdgeInsets.only(top: 8),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: list[index],
                                chatUser: widget.user!,
                              );
                            });
                      } else {
                        return const Center(
                          child: Text(
                            "Say hii ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        );
                      }
                  }
                }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: _inputChat(),
            ),
          ),
        ],
      ),
    );
  }

  _inputChat() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "write message..."),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile>? image =
                        await picker.pickMultiImage(imageQuality: 70);

                    if (image != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SendImagePage(
                              chatUser: widget.user!, image: image),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.photo,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);

                    if (image != null) {
                      File imageFile = File(image.path);
                      await DBHelper.sendChatImage(widget.user!, imageFile);
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        MaterialButton(
          height: 50,
          minWidth: 50,
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
          onPressed: () {
            String message = messageController.text;
            if (messageController.text.isNotEmpty) {
              DBHelper.sendMessage(widget.user!, message, Type.text);
              DBHelper.pushNotification(widget.user!, message);
              messageController.text = '';
            }
          },
          shape: const CircleBorder(),
          color: Colors.blue,
          child: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
