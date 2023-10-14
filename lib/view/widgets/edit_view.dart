import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../controller/home_screen_controller.dart';
import '../../../data/images.dart';
import '../widgets/transformable_asset.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/action_button.dart';

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  List<GlobalKey<TransformableAssetState>> keys = [];
  List<Widget> stackChildren = [];
  final GlobalKey repaintKey = GlobalKey();
  final scrollController = ScrollController();

  Future _postImage() async {
    deactivateAllAssets();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final boundary = repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final result =
            await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));
        if (result != null && result.isNotEmpty) {
          showSnackBar("Image saved!");
          closePage();
        } else {
          showSnackBar("Failed to save image...");
        }
      } else {
        showSnackBar("Failed to capture Image...");
      }
    });
  }

  closePage() {
    Provider.of<HomeScreenController>(context, listen: false).postWrapUp();
  }

  _addNewAsset(String assetPath) {
    deactivateAllAssets();
    setState(() {
      keys.add(GlobalKey<TransformableAssetState>());
      stackChildren.add(TransformableAsset(
        assetPath: assetPath,
        callBack: deactivateAllAssets,
        key: keys[keys.length - 1],
      ));
    });
  }

  deactivateAllAssets() {
    for (GlobalKey<TransformableAssetState> key in keys) {
      key.currentState!.unFocus();
    }
  }

  deleteAsset() {
    for (var i = 0; i < keys.length; i++) {
      if (keys[i].currentState!.checkMode()) {
        stackChildren.removeAt(i);
        keys.removeAt(i);
        return;
      }
    }
  }

  bringAssetToFront() {
    for (var i = 0; i < keys.length; i++) {
      if (keys[i].currentState!.checkMode()) {
        if (i == keys.length - 1) {
          return;
        }
        var tempStackChild = stackChildren[stackChildren.length - 1];
        var tempKey = keys[keys.length - 1];
        stackChildren[stackChildren.length - 1] = stackChildren[i];
        keys[keys.length - 1] = keys[i];
        stackChildren[i] = tempStackChild;
        keys[i] = tempKey;
        return;
      }
    }
  }

  sendAssetToBack() {
    for (var i = 0; i < keys.length; i++) {
      if (keys[i].currentState!.checkMode()) {
        if (i == 0) {
          return;
        }
        var tempStackChild = stackChildren[0];
        var tempKey = keys[0];
        stackChildren[0] = stackChildren[i];
        keys[0] = keys[i];
        stackChildren[i] = tempStackChild;
        keys[i] = tempKey;
        return;
      }
    }
  }

  showSnackBar(String test) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          test,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenController = Provider.of<HomeScreenController>(context);
    Images images = Images();

    Widget yetPost() {
      if (screenController.image != null) {
        return Image.file(
          screenController.image!,
          fit: BoxFit.cover,
        );
      } else {
        return Center(
            child: Icon(
          Icons.photo_outlined,
          size: 150,
          color: Theme.of(context).colorScheme.inversePrimary,
        ));
      }
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            screenController.toPageOne();
                          },
                          child: Text("Previous",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        TextButton(
                          onPressed: () {
                            _postImage();
                          },
                          child: Text("Post",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ]),
                ),
              ),
              RepaintBoundary(
                key: repaintKey,
                child: SizedBox.square(
                  dimension: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          deactivateAllAssets();
                        },
                        child: Container(
                          color: Colors.deepOrange[50],
                          child: SizedBox.square(
                              dimension: MediaQuery.of(context).size.width,
                              child: yetPost()),
                        ),
                      ),
                      ...stackChildren
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 116,
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      itemCount: images.assets.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _addNewAsset(images.assets[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              images.assets[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ExpandableFab(distance: 112, children: [
              ActionButton(
                icon: Icon(
                  Icons.move_up,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: () {
                  setState(() {
                    bringAssetToFront();
                  });
                },
              ),
              ActionButton(
                icon: Icon(
                  Icons.move_down,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: () {
                  setState(() {
                    sendAssetToBack();
                  });
                },
              ),
              ActionButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: () {
                  setState(() {
                    deleteAsset();
                  });
                },
              )
            ]),
          ),
        )
      ],
    );
  }
}
