
import 'dart:async';
import 'dart:convert';

import 'package:aws3_bucket/iam_crediental.dart';
import 'package:flutter/services.dart';

import 'image_data.dart';
enum IdentityType {IAM_CREDENTIALS, COGNITO_CREDENTIALS}
class Aws3Bucket {
  static const MethodChannel _channel =
      const MethodChannel('aws3_bucket');
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String?> upload(String bucket, String region,
      String subRegion, ImageData imageData, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async {
    if(iamCrediental.sercetId==null && iamCrediental.sercetKey==null || iamCrediental.identity==null){
      print("Please provide valid Crediental");
      return null;
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'filePath': imageData.filePath,
      'bucket': bucket,
      'identity': iamCrediental.identity,
      'sercetKey':iamCrediental.sercetKey,
      'sercetId':iamCrediental.sercetId,
      'imageName': imageData.fileName,
      'imageUploadFolder': imageData.imageUploadFolder,
      'region': region,
      'subRegion': subRegion,
    };

    final dynamic status =
    await _channel.invokeMethod('uploadImage', params);

    print("getting response----$status");
    if(status!){
      var path = imageData.imageUploadFolder!=null ? "${imageData.imageUploadFolder}/" : "" ;
      print("path-------"+path);
      RegExp(r'^[a-zA-Z0-9]+$');
      if(BucketValidator.validate(bucket)){
        return  "https://"+bucket+".s3.amazonaws.com/"+path+imageData.fileName;
      }else{
        return  "https://s3.amazonaws.com/"+bucket+"/"+path+imageData.fileName;
      }
    }else{
      return null;
    }
  }

  static Future<bool?> delete(
      String bucket,
      String identity,
      String imageName,
      String? folderInBucketWhereImgIsUploaded,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'bucket': bucket,
      'imageName': imageName,
      'region': region,
      'subRegion': subRegion,
      'identity': iamCrediental.identity,
      'sercetKey':iamCrediental.sercetKey,
      'sercetId':iamCrediental.sercetId,
      'imageUploadFolder': folderInBucketWhereImgIsUploaded,
    };
    final dynamic imagePath =
    await _channel.invokeMethod('deleteImage', params);
    return imagePath;
  }

  static Future<List<String>?> uploadMultiplImages(
      String bucket,
      String region,
      String subRegion, List<ImageData> listImages, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async {
    if(iamCrediental.sercetId==null && iamCrediental.sercetKey==null || iamCrediental.identity==null){
      print("Please provide valid Crediental");
      return null;
    }
    List<String> list = [];
    for(int i =0; i<listImages.length; i++){
      final Map<String, dynamic> params = <String, dynamic>{
        'filePath': listImages[i].filePath,
        'bucket': bucket,
        'identity': iamCrediental.identity,
        'sercetKey':iamCrediental.sercetKey,
        'sercetId':iamCrediental.sercetId,
        'imageName': listImages[i].fileName,
        'imageUploadFolder': listImages[i].imageUploadFolder,
        'region': region,
        'subRegion': subRegion,
        'needMultipartUpload': needMultipartUpload
      };
      final dynamic status = await _channel.invokeMethod('uploadImage', params);

      print("getting response----$status");
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

  static Future<bool?> deleteMultipleImage(
      String bucket,
      String identity,
      List<ImageData> imageList,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async {
    for(int i =0; i< imageList.length; i++){
      final Map<String, dynamic> params = <String, dynamic>{
        'bucket': bucket,
        'imageName': imageList[i].fileName,
        'region': region,
        'subRegion': subRegion,
        'identity': iamCrediental.identity,
        'sercetKey':iamCrediental.sercetKey,
        'sercetId':iamCrediental.sercetId,
        'imageUploadFolder': imageList[i].imageUploadFolder,
      };
      final dynamic result =
      await _channel.invokeMethod('deleteImage', params);
      if(!result){
        return result;
      }

    }
    return true;
  }
}

class BucketValidator {
  static bool validate(String value) {
    return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? true : false;
  }
}