import 'dart:io';
import 'package:chat_app/model/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../DB Manager/database_halper.dart';

class SendImagePage extends StatelessWidget {
  final ChatUser chatUser;
  final List<XFile> image;
  const SendImagePage({Key? key, required this.chatUser, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            File imageUrl = File(image[index].path);
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          itemCount: image.length,
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pop();
          for (var i in image) {
            File imageFile = File(i.path);
            await DBHelper.sendChatImage(chatUser, imageFile);
            DBHelper.pushNotification(chatUser, "📷 Photo");
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
