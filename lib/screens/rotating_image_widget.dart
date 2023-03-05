import 'dart:math';

import 'package:flutter/cupertino.dart';

class RotatingImage extends StatefulWidget {
  final String imagePath;
  final double size;
  final AnimationController animationController;
  RotatingImage({required this.imagePath, required this.size, required this.animationController});
  @override
  _RotatingImageState createState() => _RotatingImageState(animationController);
}

class _RotatingImageState extends State<RotatingImage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  _RotatingImageState(this._animationController);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 2 * pi,
          child: Image.asset(
            widget.imagePath,
            height: widget.size,
            width: widget.size,
          ),
        );
      },
    );
  }
}