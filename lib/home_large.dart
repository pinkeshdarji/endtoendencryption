// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
//
// import 'channel_list.dart';
// import 'channel_page.dart';
//
// class HomeLargeScreen extends StatelessWidget {
//    ValueNotifier<Channel?> _selectedChannel = ValueNotifier(null);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 children: [
//                   ListHeader(),
//                   Divider(),
//                   Expanded(
//                     child: ChannelListPage(
//                       onItemTap: (channel) => _selectedChannel.value = channel,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: ValueListenableBuilder(
//                 valueListenable: _selectedChannel,
//                 builder: (BuildContext context, value, child) {
//                   if (value == null) {
//                     return child!;
//                   } else {
//                     return StreamChannel(
//                       key: ValueKey<String>(value.cid),
//                       channel: value,
//                       child: ChannelPage(
//                         showBackButton: false,
//                       ),
//                     );
//                   }
//                 },
//                 child: GettingStarted(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class GettingStarted extends StatelessWidget {
//   const GettingStarted({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (rect) => LinearGradient(colors: [
//         Color(0xFFc3fcff),
//         Color(0xFF6c74ff),
//       ]).createShader(rect),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.chat,
//             size: 100.0,
//             color: Colors.white,
//           ),
//           Text(
//             "Select a channel to see messages!",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ListHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.white,
//             backgroundImage:
//                 NetworkImage(StreamChat.of(context).user.extraData['image']),
//             // child:
//             //     Image.network(StreamChat.of(context).user.extraData['image']),
//           ),
//           const SizedBox(width: 12.0),
//           Text(
//             "${StreamChat.of(context).user.name} ",
//             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
//           ),
//           Spacer(),
//           Icon(Icons.more_vert)
//         ],
//       ),
//     );
//   }
// }
