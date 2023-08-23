import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/chat%20side/image_viewer.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final ChatUser chatUser;
  const MessageCard({Key? key, required this.message, required this.chatUser})
      : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  var finalDate = "";

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(widget.message.sent);
    finalDate = "${date.hour}:${date.minute}";
    return DBHelper.user.uid == widget.message.fromId ? greenBox() : blueBox();
  }

  Widget blueBox() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            finalDate,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Container(
            height: widget.message.type == Type.image ? 300 : null,
            width: widget.message.type == Type.image ? 300 : null,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8, right: 40),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              message: widget.message,
                              chatUser: widget.chatUser,
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LoadingAnimationWidget.inkDrop(
                                color: Colors.blueAccent, size: 50)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget greenBox() {
    debugPrint(widget.message.type.toString());
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            finalDate,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Container(
            height: widget.message.type == Type.image ? 300 : null,
            width: widget.message.type == Type.image ? 300 : null,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8, left: 40),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              message: widget.message,
                              chatUser: widget.chatUser,
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LoadingAnimationWidget.inkDrop(
                                color: Colors.blueAccent, size: 50)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
