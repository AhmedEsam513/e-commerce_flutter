import 'package:flutter/material.dart';

class CarouselSliderItem extends StatelessWidget {
  final String url;
  final String title;

  const CarouselSliderItem({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(url,
              height: isPortrait? deviceSize.height *0.28 : deviceSize.height*0.7,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
