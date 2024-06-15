import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final IconData child;
  final bool canShow;
  final VoidCallback onTap;

  const CardWidget({
    required this.child,
    required this.canShow,
    required this.onTap,
    super.key,
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.canShow) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.canShow != oldWidget.canShow) {
      if (widget.canShow) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isUnder = _animation.value < 0.5;
          return Transform(
            transform: Matrix4.rotationY(_animation.value * 3.1415927),
            alignment: Alignment.center,
            child: isUnder
                ? Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(''),
                    ),
                  )
                : Transform(
                    transform: Matrix4.rotationY(3.1415927),
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(widget.child, size: 48, color: Colors.teal),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}