import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/config/agora_config.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/model/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = "https://whatsapp-clone-zayan.herokuapp.com";

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: client == null
            ? const LoadingHandel()
            : Stack(
          children: [
            AgoraVideoViewer(client: client!),
            AgoraVideoButtons(
              client: client!,
              disconnectButtonChild: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () async {
                    await client!.engine.leaveChannel();
                    ref.read(callControllerProvider).endCall(
                      context: context,
                      callerId: widget.call.callerId,
                      receiverId: widget.call.receiverId,
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.call_end_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
