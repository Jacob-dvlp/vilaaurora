import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ScaleInfo {
  const ScaleInfo(this.file, this.width, this.height, this.compressFormat);
  final File file;
  final int width;
  final int height;
  final CompressFormat compressFormat;
}
