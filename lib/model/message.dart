class Message {
  late final String msg;
  late final Type type;
  late final String sent;
  late final String toId;
  late final String fromId;
  late final String read;

  Message({
    required this.msg,
    required this.type,
    required this.sent,
    required this.toId,
    required this.fromId,
    required this.read,
  });

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    type = json['type'].toString() == 'Type.image' ? Type.image : Type.text;
    sent = json['sent'].toString();
    toId = json['toId'].toString();
    fromId = json['fromId'].toString();
    read = json['read'].toString();
  }

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'type':
            type == Type.image ? Type.image.toString() : Type.text.toString(),
        'sent': sent,
        'toId': toId,
        'fromId': fromId,
        'read': read,
      };
}

enum Type { text, image }
