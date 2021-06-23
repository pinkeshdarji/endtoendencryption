import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'home_small.dart';

// This sample uses GetStream for chat. To get started, please see https://getstream.io/chat/flutter/tutorial/
Future<void> main() async {
  final client = StreamChatClient(
    'ue75xxvdjwwa',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(
      id: 'Pinkesh',
      extraData: {
        'image': 'https://picsum.photos/id/1025/200/300',
      },
    ),
    client.devToken('Pinkesh'),
  );

  final channel = client.channel(
    "messaging",
    id: "guitarist",
    extraData: {
      "name": "Guitarist",
      "image": "https://source.unsplash.com/5HltXT-6Vgw",
      "members": ['Pinkesh', 'Jhon'],
    },
  );

  await channel.watch();

  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.client}) : super(key: key);
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    final theme =
        ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark);

    return StreamChat(
      client: client,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          builder: (context, child) => StreamChat(
                streamChatThemeData: StreamChatThemeData.fromTheme(theme),
                client: client,
                child: child,
              ),
          home: HomeSmallScreen()),
    );
  }
}
