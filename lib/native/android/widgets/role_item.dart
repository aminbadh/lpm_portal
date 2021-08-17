import 'package:flutter/material.dart';

class RoleItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Function onClick;

  const RoleItem({Key key, @required this.imagePath, @required this.title, @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResizeImage(AssetImage(imagePath), height: 100, width: 100);
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage(imagePath),
                size: 100,
              ),
              SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
