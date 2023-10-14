import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera-screen';
  const CameraScreen({required this.cameraList, super.key});

  final List<CameraDescription> cameraList;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool flashOn = false;

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future initCamera() async {
    controller = CameraController(widget.cameraList[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _showErrorSnackBar(e.toString());
            break;
          default:
            _showErrorSnackBar(e.toString());
            break;
        }
      }
    });
  }

  _showErrorSnackBar(String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        errorText,
      ),
    ));
  }

  toggleFlash() {
    if (!controller.value.isInitialized) {
      return;
    }
    setState(() {
      flashOn = !flashOn;
      if (flashOn) {
        controller.setFlashMode(FlashMode.auto);
      } else {
        controller.setFlashMode(FlashMode.off);
      }
    });
  }

  Future<XFile?> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      XFile picture = await controller.takePicture();
      return picture;
    } on CameraException catch (e) {
      _showErrorSnackBar('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: toggleFlash,
              icon: Icon(flashOn ? Icons.flash_auto : Icons.flash_off, color: Colors.white,)),
        ],
      ),
      body: !controller.value.isInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(color: Colors.black,),
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRect(
                    child: SizedOverflowBox(
                      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                      alignment: Alignment.center,
                      child: CameraPreview(
                        controller
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        color: Colors.black),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 50,
                            color: Colors.white,
                          ),
                          IconButton(
                            iconSize: 65,
                            padding: const EdgeInsets.all(1),
                            onPressed: () async {
                              await takePicture().then((value) {
                                if (value != null) {
                                  Navigator.pop(context, value);
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
