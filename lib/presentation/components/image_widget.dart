import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    required this.url,
    this.width,
    this.height,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isNetwork = url.startsWith('http://') || url.startsWith('https://');
    return isNetwork
        ? CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.fill,
            width: width,
            height: height,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(
              Icons.broken_image,
              size: height,
            ),
          )
        : Image.file(
            File(url),
            width: width,
            height: height,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          );
  }
}
