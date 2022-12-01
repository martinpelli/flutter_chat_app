import 'dart:convert';

MessagesResponse messagesResponseFromMap(String str) => MessagesResponse.fromMap(json.decode(str));

String messagesResponseToMap(MessagesResponse data) => json.encode(data.toMap());

class MessagesResponse {
  MessagesResponse({
    required this.ok,
    required this.messages,
  });

  final bool ok;
  final List<Message> messages;

  factory MessagesResponse.fromMap(Map<String, dynamic> json) => MessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toMap())),
      };
}

class Message {
  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  final String from;
  final String to;
  final String message;
  final String createdAt;
  final String updatedAt;

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toMap() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
