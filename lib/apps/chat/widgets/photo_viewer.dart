import 'package:photo_view/photo_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoViewer extends ConsumerWidget {
  static final routeName = "/photo-viewer";
  final String imageUrl;
  const PhotoViewer ({super.key, required this.imageUrl});

  @override
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    appBar: AppBar(title: Text("Photo Viewer")),
    body: Container(
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      )
    ),
  );
}
}