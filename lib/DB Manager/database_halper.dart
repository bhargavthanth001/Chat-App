import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class DBHelper {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<bool> userExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.providerData[0].email.toString(),
      image: user.photoURL.toString(),
      about: "Hii , ia ma using flutter chat",
      isOnline: false,
      createdAt: time,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Future<void> selfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        debugPrint("data is :- ${user.data()}");
      } else {
        createUser().then(
          (value) => selfInfo(),
        );
      }
    });
  }

  static Stream<List<ChatUser>> getAllUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => ChatUser.fromJson(doc.data())).toList());
  }

  static Stream<ChatUser> getSingleUser() {
    return firestore
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .map((event) => ChatUser.fromJson(event.data()!));
  }

  static String getConversionId(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : "${id}_${user.uid}";

  static Stream<List<Message>> getAllMessage(ChatUser chatUser) {
    return firestore
        .collection("chats/${getConversionId(chatUser.id)}/messages")
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().toString();
    debugPrint(time);

    final message = Message(
        msg: msg,
        type: type,
        sent: time,
        toId: chatUser.id,
        fromId: user.uid,
        read: '');

    final ref =
        firestore.collection("chats/${getConversionId(chatUser.id)}/messages");

    await ref.doc(time).set(message.toJson());
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversionId(chatUser.id)}/${DateTime.now().toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> getFirebaseMessagingToken() async {
    await messaging.requestPermission();

    await messaging.getToken().then(
      (tokenValue) {
        if (tokenValue != null) {
          me.pushToken = tokenValue;
          debugPrint("Firebase Message Token :- ${me.pushToken}");
          updatePushToken();
        }
      },
    );
  }

  static Future<void> updatePushToken() async {
    firestore.collection("users").doc(user.uid).update(
      {
        'push_token': me.pushToken,
      },
    );
  }

  static Future<void> pushNotification(ChatUser chatUser, String msg) async {
    final body = {
      "to": chatUser.pushToken,
      "notification": {
        "title": chatUser.name,
        "body": msg,
      }
    };
    debugPrint(chatUser.pushToken);
    String token =
        "key=AAAASgxBZ4U:APA91bFgzp6-AeJsHOCcL4v8a03-d9eKKKv781QsYvm0RNUq98A8DwHZIbrMCOza4cdGe9UQCToHoDjDPbIetCe4iL0R_H_4jrhhNDdY-kie3Gd9c4mzUntxqShMUk5Hf7zbDcaVRu_X";
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
    } else {
      debugPrint("Failed to load...");
    }
  }

  static Future<void> updateName(String data) async {
    await firestore.collection("users").doc(user.uid).update({"name": data});
  }

  static Future<void> updateAbout(String data) async {
    await firestore.collection("users").doc(user.uid).update({"about": data});
  }
}
