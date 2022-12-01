import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> chatMessages = [];

  bool isWriting = false;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('message', onMessageReceived);

    _loadChatMessages(chatService.receptorUser!.uid);

    super.initState();
  }

  void _loadChatMessages(String uid) async {
    List<Message> messages = await chatService.getMessagesFromChat(uid);

    final List<ChatMessage> previousChatMessages = messages
        .map((m) => ChatMessage(
            text: m.message, uid: m.from, animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200))))
        .toList();

    setState(() {
      chatMessages.insertAll(0, previousChatMessages);
    });
  }

  void onMessageReceived(dynamic data) {
    final ChatMessage chatMessage = ChatMessage(
        text: data['message'], uid: data['from'], animationController: AnimationController(vsync: this, duration: const Duration(microseconds: 200)));

    setState(() {
      chatMessages.insert(0, chatMessage);
    });

    chatMessage.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in chatMessages) {
      message.animationController.dispose();
    }

    socketService.socket.off('message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User destinationUser = chatService.receptorUser!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
                maxRadius: 15,
                backgroundColor: Colors.blue[100],
                child: const Text(
                  'jua',
                  style: TextStyle(fontSize: 12),
                )),
            const SizedBox(height: 3.0),
            Text(
              destinationUser.name,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
            reverse: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => chatMessages[index],
            itemCount: chatMessages.length,
          )),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _InputChat(
                isWriting: isWriting,
                onChanged: (value) => setState(() {
                      _textController.text.trim().isEmpty ? isWriting = false : isWriting = true;
                    }),
                onSubmitted: (String _) => _handleMessage(),
                onPressed: () {
                  _handleMessage();

                  _focusNode.requestFocus();
                },
                controller: _textController,
                focusNode: _focusNode),
          )
        ],
      ),
    );
  }

  void _handleMessage() {
    if (_textController.text.isEmpty) return;

    final newMessage = ChatMessage(
        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
        text: _textController.text,
        uid: authService.user!.uid);
    chatMessages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      isWriting = false;
    });

    socketService.emit('message', {'from': authService.user!.uid, 'to': chatService.receptorUser!.uid, 'message': _textController.text});

    _textController.clear();
  }
}

class _InputChat extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final void Function() onPressed;
  final bool isWriting;

  const _InputChat({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.isWriting,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [
        Flexible(
            child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          decoration: const InputDecoration.collapsed(hintText: 'Send message'),
          focusNode: focusNode,
        )),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(child: const Text('Send'), onPressed: () {})
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.blue[400],
                      ),
                      child: IconButton(
                          onPressed: isWriting ? onPressed : null,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(
                            Icons.send,
                          )),
                    ),
                  ))
      ]),
    );
  }
}
