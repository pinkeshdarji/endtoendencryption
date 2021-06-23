import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key key, this.onItemTap}) : super(key: key);

  final ValueChanged<Channel> onItemTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: ChannelsBloc(
        child: ChannelListView(
          onChannelTap: onItemTap != null
              ? (channel, _) {
                  onItemTap(channel);
                }
              : null,
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user.id],
            }
          },
          sort: [SortOption('last_message_at')],
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}
