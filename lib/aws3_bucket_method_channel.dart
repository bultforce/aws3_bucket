import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aws3_bucket.dart';
import 'aws3_bucket_platform_interface.dart';
import 'iam_crediental.dart';
import 'image_data.dart';

/// An implementation of [Aws3BucketPlatform] that uses method channels.
class MethodChannelAws3Bucket extends Aws3BucketPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('aws3_bucket');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> getDeleteMultipleImages(
      String bucket,
      String identity,
      List<ImageData> imageList,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async{
    for(int i =0; i< imageList.length; i++){
      final Map<String, dynamic> params = <String, dynamic>{
        'bucket': bucket,
        'imageName': imageList[i].fileName,
        'region': region,
        'subRegion': subRegion,
        'identity': iamCrediental.identity,
        'secretKey':iamCrediental.secretKey,
        'secretId':iamCrediental.secretId,
        'imageUploadFolder': imageList[i].imageUploadFolder,
      };
      final dynamic result =
          await methodChannel.invokeMethod('deleteImage', params);
      if(!result){
        return result;
      }

    }
    return true;
  }


  @override
  Future<bool?> getDeleteImage(
      String bucket,
      String imageName,
      String? folderInBucketWhereImgIsUploaded,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async{
    final Map<String, dynamic> params = <String, dynamic>{
      'bucket': bucket,
      'imageName': imageName,
      'region': region,
      'subRegion': subRegion,
      'identity': iamCrediental.identity,
      'secretKey':iamCrediental.secretKey,
      'secretId':iamCrediental.secretId,
      'imageUploadFolder': folderInBucketWhereImgIsUploaded,
    };
    final dynamic imagePath =
        await methodChannel.invokeMethod('deleteImage', params);
    return imagePath;
  }

  @override
  Future<List<String>> getUploadMultipleImages(String bucket, String region,
      String subRegion, List<ImageData> listImages, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async{
    List<String> list = [];
    for(int i =0; i<listImages.length; i++){
      final Map<String, dynamic> params = <String, dynamic>{
        'filePath': listImages[i].filePath,
        'bucket': bucket,
        'identity': iamCrediental.identity,
        'secretKey':iamCrediental.secretKey,
        'secretId':iamCrediental.secretId,
        'imageName': listImages[i].fileName,
        'imageUploadFolder': listImages[i].imageUploadFolder,
        'region': region,
        'subRegion': subRegion,
        'needMultipartUpload': needMultipartUpload
      };
      final dynamic status = await methodChannel.invokeMethod('uploadImage', params);

      if(status!){
        var path = listImages[i].imageUploadFolder!=null ? "${listImages[i].imageUploadFolder}/" : "" ;
        if(BucketValidator.validate(bucket)){
          list.add("https://"+bucket+".s3.amazonaws.com/"+path+listImages[i].fileName) ;
        }else{
          list.add("https://s3.amazonaws.com/"+bucket+"/"+path+listImages[i].fileName);
        }
      }
    }
    return list;
  }


  @override
  Future<bool?> getUploadImage(String bucket, String region, String subRegion,
      ImageData imageData, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async{

    final Map<String, dynamic> params = <String, dynamic>{
      'filePath': imageData.filePath,
      'bucket': bucket,
      'identity': iamCrediental.identity,
      'secretKey':iamCrediental.secretKey,
      'secretId':iamCrediental.secretId,
      'imageName': imageData.fileName,
      'imageUploadFolder': imageData.imageUploadFolder,
      'region': region,
      'subRegion': subRegion,
    };
    print("getUploadImage:---$params");

    return await methodChannel.invokeMethod('uploadImage', params);
  }
}
