import 'dart:async';
import 'dart:io';
import 'package:aws3_bucket/aws3_bucket.dart';
import 'package:aws3_bucket/aws_region.dart';
import 'package:aws3_bucket/iam_crediental.dart';
import 'package:aws3_bucket/image_data.dart';
import 'package:aws3_bucket_example/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aws3 Bucket",
      home: Scaffold(body: AwsPluginTest()),
    );
  }
}

class AwsPluginTest extends StatefulWidget {
  @override
  AwsPluginTestState createState() => AwsPluginTestState();
}

class AwsPluginTestState extends State<AwsPluginTest> {
  File? selectedFile;

  Aws3Bucket aws3bucket = Aws3Bucket();
  bool isLoading = false;
  bool uploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AwsPluginExample"),),
      body: Center(
        child: selectedFile != null
            ? isLoading
            ? CircularProgressIndicator()
            : Image.file(selectedFile!)
            : GestureDetector(
          onTap: () async {
            PickedFile _pickedFile = (await ImagePicker().getImage(source: ImageSource.gallery))!;
            setState(() {
              selectedFile = File(_pickedFile.path);
            });
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      floatingActionButton: !isLoading
          ? FloatingActionButton(
        backgroundColor: uploaded ? Colors.green : Colors.blue,
        child: Icon(
          uploaded ? Icons.delete : Icons.arrow_upward,
          color: Colors.white,
        ),
        onPressed: () async {

          if (selectedFile != null){
            _upload(selectedFile);
          }else{
            _delete();
          }
        },
      )
          : null,
    );
  }

  Future<String?> _upload(File? selectedFile) async {
    String? result;
    IAMCrediental iamCrediental = IAMCrediental();
    iamCrediental.secretKey = Constant.awsSecertKey;
    iamCrediental.secretId = Constant.awsSecretId;
    ImageData imageData = ImageData(DateTime.now().millisecondsSinceEpoch.toString(), selectedFile!.path, imageUploadFolder: "testing");
   result= await Aws3Bucket.upload(Constant.bucket, AwsRegion.AP_EAST_1,AwsRegion.AP_EAST_1, imageData, iamCrediental);
   print(result);
   if(result!=null){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
   }else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
   }
    return result;
  }

  Future<bool?> _delete() async {
    bool? result;
    IAMCrediental iamCrediental = IAMCrediental();
    iamCrediental.secretKey = Constant.awsSecertKey;
    iamCrediental.secretId = Constant.awsSecretId;
    result= await Aws3Bucket.delete(Constant.bucket, "1660476300927.png", "testing", AwsRegion.AP_EAST_1, iamCrediental, AwsRegion.AP_EAST_1,  );
    print(result);
    if(result!=null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("deleted successfully")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
    selectedFile = null;
    setState(() {

    });
    return result;
  }
}