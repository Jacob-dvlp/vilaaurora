import 'dart:async';
import 'dart:io';

import 'package:file/local.dart' as fileio;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:sprintf/sprintf.dart';

import '../debug_tools.dart';
import 'scale_info.dart';

class DefaultImageTransformer extends ImageTransformer {
  DefaultImageTransformer();

  final String tmpFileSuffix = '_w%d_h%d';

  final Map<String, CompressFormat> _compressionFormats =
      <String, CompressFormat>{
    '.jpg': CompressFormat.jpeg,
    '.jpeg': CompressFormat.jpeg,
    '.webp': CompressFormat.webp,
    '.png': CompressFormat.png,
    '.heic': CompressFormat.heic,
  };
  final Map<CompressFormat, String> _extensionFormats =
      <CompressFormat, String>{
    CompressFormat.jpeg: '.jpg',
    CompressFormat.webp: '.webp',
    CompressFormat.png: '.png',
    CompressFormat.heic: '.heic'
  };

  @override
  Future<FileInfo> transform(FileInfo info, int width, int height) async {
    final FileInfo value = await _scaleImageFile(info, width, height);
    return value;
  }

  Future<FileInfo> _scaleImageFile(FileInfo info, int width, int height) async {
    FileInfo fileInfo = info;
    final File file = fileInfo.file;
    log('Scaling file.. ${fileInfo.originalUrl}');
    File resizedFile = file;
    if (file.existsSync() && (width != null || height != null)) {
      final ScaleInfo scaleInfo = getScaledFileInfo(file, width, height);
      final int srcSize = file.lengthSync();
      log('Dimensions width=${scaleInfo.width}, height=${scaleInfo.height}, format ${scaleInfo.compressFormat}');
      await FlutterImageCompress.compressAndGetFile(
          file.path, scaleInfo.file.path,
          minWidth: scaleInfo.width,
          minHeight: scaleInfo.height,
          format: scaleInfo.compressFormat,
          quality: 90);
      const fileio.LocalFileSystem localFileSystem = fileio.LocalFileSystem();
      resizedFile = localFileSystem.file(scaleInfo.file.path);
      if (resizedFile != null && resizedFile.existsSync()) {
        if (resizedFile.lengthSync() < srcSize) {
          log('Resized success ${fileInfo.originalUrl}');
        } else {
          log('Resized image is bigger, deleting and using original ${fileInfo.originalUrl}');
          resizedFile.deleteSync();
          resizedFile = file;
        }
      } else {
        resizedFile = file;
        log('Resize Failure for ${fileInfo.originalUrl}');
      }
    }
    fileInfo = FileInfo(
        resizedFile, fileInfo.source, fileInfo.validTill, fileInfo.originalUrl);
    return fileInfo;
  }

  @override
  ScaleInfo getScaledFileInfo(File file, int width, int height) {
    final CompressFormat format = _getCompressionFormat(file);

    final Directory directory = file.parent;
    final String destPath = directory.path +
        '/' +
        p.basenameWithoutExtension(file.path) +
        sprintf(tmpFileSuffix, <int>[width ?? 1, height ?? 1]) +
        _extensionFormats[format];
    final File scaleFile = File(destPath);
    return ScaleInfo(scaleFile, width ?? 1, height ?? 1, format);
  }

  CompressFormat _getCompressionFormat(File file) {
    final String extension = p.extension(file.path) ?? '';
    return _compressionFormats[extension] ?? CompressFormat.png;
  }
}

abstract class ImageTransformer {
  Future<FileInfo> transform(FileInfo info, int width, int height);
  ScaleInfo getScaledFileInfo(File file, int width, int height);
}
