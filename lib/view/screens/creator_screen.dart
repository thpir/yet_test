import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_view.dart';
import '../widgets/edit_view.dart';
import '../../../controller/home_screen_controller.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  static const List<Widget> views = [
    CreateView(),
    EditView(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenController = Provider.of<HomeScreenController>(context);
    return views[screenController.selectedSubView];
  }
}
