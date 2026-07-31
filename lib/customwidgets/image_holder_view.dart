import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:telescope_mart/models/image_model.dart';

class ImageHolderView extends StatelessWidget {
  final ImageModel imageModel;
  final VoidCallback onPressed;
  const ImageHolderView({
    super.key,
    required this.imageModel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .all(8),
      width: 80,
      height: 80,
      alignment: .center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: InkWell(
        onTap: onPressed,
        child: CachedNetworkImage(
          imageUrl: imageModel.downloadUrl,
          fit: .cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
