# aws3_bucket

It is just simple to use AWS S3 plugin for upload and deletion image, pdf or any kind of files to AWS3 public bucket

Aws S3 uses AWS Native SDKs for iOS and Android

## Getting Started
Add dependency in pubspec.yaml
aws3_bucket: 

##  Features

| Feature | Description |
| ----- | ----------- |
| Null Safe | :white_check_mark: |
| Supports all files | Aws3 can upload any kind of file to AWS, you don't have to care about file, just simply add file path and name, |
| Aws Region Helper | All Available Aws region availble in our list |
| Upload Image | Add Path or name of image directly |
|Custom File Name| Allows to change name of file about to upload.|
| Custom S3 folder path| Allows to upload file to specific folder in S3|
| Sub Region Support | Allows upload/delete operations on S3 having sub regions |
| Delete Object | Allows deletion of file object |
| Auto Generates URL| URL pointing to S3 file is auto generated. <br>  |

<br>
<br>

## Usage Examples

### File Upload

```dart

// returns url pointing to S3 file

Future<String?> _upload(File? selectedFile) async {
  IAMCrediental iamCrediental = IAMCrediental();
  iamCrediental.secretKey = Constant.awsSecertKey;
  iamCrediental.secretId = Constant.awsSecretId;
  ImageData imageData = ImageData(DateTime.now().millisecondsSinceEpoch.toString(), selectedFile!.path, imageUploadFolder: "testing");
  return  await Aws3Bucket.upload(Constant.bucket, AwsRegion.AP_EAST_1,AwsRegion.AP_EAST_1, imageData, iamCrediental);
}

```


```dart

// deleting s3 file

Future<bool?> _delete() async {
  IAMCrediental iamCrediental = IAMCrediental();
  iamCrediental.secretKey = Constant.awsSecertKey;
  iamCrediental.secretId = Constant.awsSecretId;
  return await Aws3Bucket.delete(Constant.bucket, "1660476300927.png", "testing", AwsRegion.AP_EAST_1, iamCrediental, AwsRegion.AP_EAST_1,  );
}

```

