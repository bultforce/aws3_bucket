import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aws3_bucket_method_channel.dart';
import 'iam_crediental.dart';
import 'image_data.dart';

abstract class Aws3BucketPlatform extends PlatformInterface {
  /// Constructs a Aws3BucketPlatform.
  Aws3BucketPlatform() : super(token: _token);

  static final Object _token = Object();

  static Aws3BucketPlatform _instance = MethodChannelAws3Bucket();

  /// The default instance of [Aws3BucketPlatform] to use.
  ///
  /// Defaults to [MethodChannelAws3Bucket].
  static Aws3BucketPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Aws3BucketPlatform] when
  /// they register themselves.
  static set instance(Aws3BucketPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> getUploadImage(String bucket, String region,
      String subRegion, ImageData imageData, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) {
    throw UnimplementedError('getUploadImage() has not been implemented.');
  }
  Future<bool?> getDeleteImage(
      String bucket,
      String imageName,
      String? folderInBucketWhereImgIsUploaded,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) {
    throw UnimplementedError('getDeleteImage() has not been implemented.');
  }
  Future<List<String>?> getUploadMultipleImages(String bucket,
      String region,
      String subRegion, List<ImageData> listImages, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) {
    throw UnimplementedError('getUploadMultipleImages() has not been implemented.');
  }
  Future<bool?> getDeleteMultipleImages( String bucket,
      String identity,
      List<ImageData> imageList,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) {
    throw UnimplementedError('getDeleteMultipleImages() has not been implemented.');
  }
}
