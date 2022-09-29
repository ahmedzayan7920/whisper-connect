import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/features/call/screens/call_screen.dart';
import 'package:chat_app/model/call_model.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Incoming Call",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            CachedNetworkImageProvider(call.callerPicture),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              ref.read(callControllerProvider).endCall(
                                    context: context,
                                    callerId: call.callerId,
                                    receiverId: call.receiverId,
                                  );
                            },
                            icon: const Icon(
                              Icons.call_end_outlined,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 25),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                    channelId: call.callId,
                                    call: call,
                                    isGroupChat: false,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.call_rounded,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
