import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/model/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = "/status_screen";
  final StatusModel status;

  const StatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> stories = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrls.length; i++) {
      stories.add(
        StoryItem.pageImage(
          url: widget.status.photoUrls[i],
          controller: controller,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: stories.isEmpty
            ? const LoadingHandel()
            : StoryView(
                storyItems: stories,
                controller: controller,
                onComplete: () => Navigator.pop(context),
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
              ),
      ),
    );
  }
}
