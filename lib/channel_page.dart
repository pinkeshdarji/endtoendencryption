import 'package:endtoendencryption/endtoendencryption/appe2ee.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
    this.showBackButton = true,
  }) : super(key: key);
  final bool showBackButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showBackButton: showBackButton,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              messageBuilder: _messageBuilder,
            ),
          ),
          MessageInput(
            disableAttachments: true,
            preMessageSending: (Message message) async {
              String encryptedMessage = await AppE2EE().encrypt(message.text);
              Message newmessage = message.copyWith(text: encryptedMessage);
              return newmessage;
            },
          ),
        ],
      ),
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
  ) {
    Message message = details.message;
    final isCurrentUser = StreamChat.of(context).user.id == message.user.id;
    final textAlign = isCurrentUser ? TextAlign.right : TextAlign.left;
    final color = isCurrentUser ? Colors.blueGrey : Colors.blue;

    return FutureBuilder<String>(
      future: AppE2EE().decrypt(message.text), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data,
                      textAlign: textAlign,
                    ),
                  ),
                ),
              );
        }
      },
    );
  }
}
