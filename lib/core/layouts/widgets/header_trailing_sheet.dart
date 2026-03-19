import 'package:shadcn_flutter/shadcn_flutter.dart';

class HeaderTrailingSheet extends StatelessWidget {
  const HeaderTrailingSheet({
    super.key,
    required this.body,
    required this.icon,
    this.position = OverlayPosition.start,
    this.shape = ButtonShape.circle,
  });

  final Widget body;
  final Icon icon;
  final OverlayPosition position;
  final ButtonShape shape;

  @override
  Widget build(BuildContext context) {
    void open(BuildContext context) {
      openSheetOverlay(
        context: context,
        builder: (context) {
          // Ensure a fresh subtree for each sheet open so disposed scroll
          // positions/controllers from prior overlays are not reused.
          return KeyedSubtree(key: UniqueKey(), child: body);
        },
        // Slide in from the end (right on LTR).
        position: position,
      );
    }

    return OutlineButton(
      density: ButtonDensity.icon,
      onPressed: () => open(context),
      shape: shape,
      child: icon,
    );
  }
}
