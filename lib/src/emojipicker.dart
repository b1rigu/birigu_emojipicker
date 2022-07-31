import 'package:birigu_emojipicker/src/emoji_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

final openEmojiIconsProvider = StateProvider.autoDispose((ref) => true);
final emojiIndexProvider = StateProvider.autoDispose((ref) => 0);

class EmojiPickerWidget extends ConsumerWidget {
  final double height;
  final Function() backspaceOnTap;
  final Function(String) emojiPressed;
  final Color backColor;
  final Color categoryColor;
  final Color iconsColor;
  final Color nameColor;
  EmojiPickerWidget({
    Key? key,
    required this.height,
    required this.backspaceOnTap,
    required this.emojiPressed,
    this.categoryColor = const Color.fromRGBO(238, 238, 238, 1),
    this.backColor = Colors.white,
    this.iconsColor = Colors.black,
    this.nameColor = Colors.black54,
  }) : super(key: key);

  final List<IconData> icons = [
    //Icons.access_time,
    Icons.emoji_emotions,
    Icons.pets,
    Icons.fastfood,
    Icons.location_city,
    Icons.directions_run,
    Icons.lightbulb,
    Icons.emoji_symbols,
    Icons.flag,
  ];

  final key0 = GlobalKey();
  final key1 = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final key4 = GlobalKey();
  final key5 = GlobalKey();
  final key6 = GlobalKey();
  final key7 = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<GlobalKey> keys = [
      key0,
      key1,
      key2,
      key3,
      key4,
      key5,
      key6,
      key7,
    ];
    final openEmojiIcons = ref.watch(openEmojiIconsProvider);
    final emojiIndex = ref.watch(emojiIndexProvider);
    return Container(
      color: backColor,
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.forward) {
                  // Handle scroll down.
                  ref.read(openEmojiIconsProvider.notifier).state = true;
                } else if (notification.direction == ScrollDirection.reverse) {
                  // Handle scroll up.
                  ref.read(openEmojiIconsProvider.notifier).state = false;
                }
              }
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                for (int i = 0; i < emojis.length; i++) ...[
                  emojiName(
                    emojis.keys.elementAt(i),
                    keys[i],
                    i,
                    ref,
                  ),
                  emojiView(emojis.values.elementAt(i)),
                ],
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              color: categoryColor,
              height: openEmojiIcons ? 45 : 0,
              width: double.infinity,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          if (emojiIndex == index) {
                            return SizedBox(
                              width: 45,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Scrollable.ensureVisible(
                                      keys[index].currentContext!,
                                    );
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Icon(
                                        icons[index],
                                        size: 22,
                                        color: iconsColor,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          height: 2,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            width: 45,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Scrollable.ensureVisible(
                                    keys[index].currentContext!,
                                  );
                                },
                                child: Icon(
                                  icons[index],
                                  size: 22,
                                  color: iconsColor,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: icons.length,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: backspaceOnTap,
                          child: Icon(
                            Icons.backspace_outlined,
                            size: 22,
                            color: iconsColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emojiName(String name, GlobalKey key, int index, WidgetRef ref) {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    return SliverVisibilityDetector(
      key: key,
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 1) {
          ref.read(emojiIndexProvider.notifier).state = index;
        }
      },
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ),
        sliver: SliverToBoxAdapter(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: nameColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget emojiView(Map<String, String> emoji) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  emojiPressed(emoji.values.elementAt(index));
                },
                child: Text(
                  emoji.values.elementAt(index),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            );
          },
          childCount: emoji.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          crossAxisCount: 8,
        ),
      ),
    );
  }
}
