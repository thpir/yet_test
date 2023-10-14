import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controller/home_screen_controller.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final ImagePicker picker = ImagePicker();

  _showSnackBar(String test) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          test,
        ),
      ),
    );
  }

  _resetImage() {
    setState(() {
      Provider.of<HomeScreenController>(context, listen: false).image = null;
    });
  }

  Future _pickImage() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        Provider.of<HomeScreenController>(context, listen: false).image =
            File(result.path);
      });
    }
  }

  Future _awaitImage() async {
    final result =
        await Navigator.of(context).pushNamed('/camera-screen') as XFile;
    if (!mounted) {
      return;
    }
    setState(() {
      Provider.of<HomeScreenController>(context, listen: false).image =
          File(result.path);
    });
  }

  Widget _yetPost() {
    if (Provider.of<HomeScreenController>(context, listen: false).image != null) {
      return Image.file(
        Provider.of<HomeScreenController>(context, listen: false).image!,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
          child: Icon(
        Icons.photo_outlined,
        size: 150,
        color: Colors.deepPurple[200],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<HomeScreenController>(context, listen: false);
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
                          onPressed: postController.image != null
                              ? _resetImage
                              : () {
                                  _showSnackBar("No image loaded to close...");
                                },
                          child: Text("Close",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        TextButton(
                          onPressed: postController.image != null
                              ? () {
                                  postController.toPageTwo();
                                }
                              : () {
                                  _showSnackBar(
                                      "Please select or take an image first...");
                                },
                          child: Text("Next",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ]),
                ),
              ),
              Container(
                color: Colors.deepPurple[50],
                child: SizedBox.square(
                    dimension: MediaQuery.of(context).size.width,
                    child: _yetPost()),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      _awaitImage();
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Take Picture")),
                ElevatedButton.icon(
                    onPressed: () {
                      _pickImage();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Select Image"))
              ],
            ),
          ),
        )
      ],
    );
  }
}
