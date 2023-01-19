import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String? imageURL;
  const ItemImage({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _boxDecoration(),
        width: double.infinity,
        height: 450,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          child: imageURL == null || imageURL == ''?
            const Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover,
            ) :
            FadeInImage(
              placeholder: const AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage(imageURL!),
              fit: BoxFit.cover,
            ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(45),
      topRight: Radius.circular(45),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0,5)
      )
    ]
  );
}