import 'dart:async';
import 'dart:convert';

import 'package:aws3_bucket/aws3_bucket_platform_interface.dart';
import 'package:aws3_bucket/iam_crediental.dart';
import 'package:flutter/services.dart';

import 'image_data.dart';

class Aws3Bucket {

  static Future<String?> get platformVersion async {
    return await Aws3BucketPlatform.instance.getPlatformVersion();
  }
  static Future<String?> upload(String bucket, String region,
      String subRegion, ImageData imageData, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async {
    if(iamCrediental.identity==null ){
      if(iamCrediental.secretId==null && iamCrediental.secretKey==null){
        return null;
      }

    }
    final dynamic status =
    await Aws3BucketPlatform.instance.getUploadImage(bucket, region, subRegion, imageData, iamCrediental, needMultipartUpload: needMultipartUpload);

    print(status);
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
      String imageName,
      String? folderInBucketWhereImgIsUploaded,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async {
    if(iamCrediental.identity==null ){
      if(iamCrediental.secretId==null && iamCrediental.secretKey==null){
        return null;
      }

    }
    return Aws3BucketPlatform.instance.getDeleteImage(bucket,  imageName, folderInBucketWhereImgIsUploaded,
        region, iamCrediental, subRegion);
  }

  static Future<List<String>?> uploadMultiplImages(
      String bucket,
      String region,
      String subRegion, List<ImageData> listImages, IAMCrediental iamCrediental,
      {bool needMultipartUpload = false}) async {
    if(iamCrediental.identity==null ){
      if(iamCrediental.secretId==null && iamCrediental.secretKey==null){
        return null;
      }

    }
    return Aws3BucketPlatform.instance.getUploadMultipleImages(bucket, region, subRegion, listImages, iamCrediental,
        needMultipartUpload: needMultipartUpload);
  }

  static Future<bool?> deleteMultipleImage(
      String bucket,
      String identity,
      List<ImageData> imageList,
      String region,
      IAMCrediental iamCrediental,
      String subRegion) async {
    if(iamCrediental.identity==null ){
      if(iamCrediental.secretId==null && iamCrediental.secretKey==null){
        return null;
      }

    }
   return Aws3BucketPlatform.instance.getDeleteMultipleImages(bucket, identity, imageList, region, iamCrediental, subRegion);
  }
}

class BucketValidator {
  static bool validate(String value) {
    return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? true : false;
  }
}