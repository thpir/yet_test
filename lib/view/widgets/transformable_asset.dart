import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

class TransformableAsset extends StatefulWidget {
  const TransformableAsset(
      {Key? key, required this.callBack, required this.assetPath})
      : super(key: key);

  final String assetPath;
  final Function callBack;

  @override
  State<TransformableAsset> createState() => TransformableAssetState();
}

class TransformableAssetState extends State<TransformableAsset> {
  bool focusMode = true;
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 300,
    height: 300,
  );

  unFocus() {
    setState(() {
      focusMode = false;
    });
  }

  focus() {
    setState(() {
      focusMode = true;
    });
  }

  bool checkMode() {
    return focusMode;
  }

  @override
  Widget build(BuildContext context) {
    return TransformableBox(
      visibleHandles: focusMode
          ? <HandlePosition>{
              HandlePosition.topLeft,
              HandlePosition.topRight,
              HandlePosition.bottomLeft,
              HandlePosition.bottomRight,
              HandlePosition.left,
              HandlePosition.top,
              HandlePosition.right,
              HandlePosition.bottom
            }
          : const <HandlePosition>{HandlePosition.none},
      rect: rect,
      resizable: focusMode ? true : false,
      draggable: focusMode ? true : false,
      onChanged: (result, event) {
        setState(() {
          rect = result.rect;
        });
      },
      contentBuilder: (BuildContext context, Rect rect, Flip flip) {
        return InkWell(
          onTap: () {
            widget.callBack();
            focus();
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: focusMode ? Colors.blue : Colors.transparent,
              ),
              image: DecorationImage(
                image: AssetImage(widget.assetPath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
