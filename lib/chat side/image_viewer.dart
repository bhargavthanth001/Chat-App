import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../DB Manager/database_halper.dart';

class ImageViewer extends StatelessWidget {
  final Message message;
  final ChatUser chatUser;
  const ImageViewer({Key? key, required this.message, required this.chatUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: DBHelper.user.uid == message.fromId
            ? const Text("You")
            : Text(chatUser.name),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: message.msg,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.blueAccent, size: 50),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image, size: 70),
        ),
      ),
    );
  }
}
