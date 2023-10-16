import 'package:flutter/material.dart';

import '../../data/images.dart';

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  Images images = Images();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.inspirationImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),],
                borderRadius: BorderRadius.circular(20)
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0),),
                child: Column(
                  children: [
                    Image.asset(images.inspirationImages[index], fit: BoxFit.cover,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Image #${index + 1}'),
                    )
                  ],
                )
              ),
            ),
          );
        });
  }
}
