import Flutter
import UIKit
import AWSS3
import AWSCore

public class SwiftAws3BucketPlugin: NSObject, FlutterPlugin {
   var region1:AWSRegionType = AWSRegionType.USEast1
   var subRegion1:AWSRegionType = AWSRegionType.EUWest1
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aws3_bucket", binaryMessenger: registrar.messenger())
    let instance = SwiftAws3BucketPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         if(call.method.elementsEqual("uploadImage")){
               uploadImageForRegion(call,result: result)
          }else if(call.method.elementsEqual("deleteImage")){
              deleteImage(call,result: result)
          }
      }

      public func nameGenerator() -> String{
          let date = Date()
          let formatter = DateFormatter()
          formatter.dateFormat = "ddMMyyyy"
          let result = formatter.string(from: date)
          return "IMG" + result + String(Int64(date.timeIntervalSince1970 * 1000)) + "jpeg"
      }


      func uploadImageForRegion(_ call: FlutterMethodCall, result: @escaping FlutterResult){
                let arguments = call.arguments as? NSDictionary
                let imagePath = arguments!["filePath"] as? String
                let bucket = arguments!["bucket"] as? String
                let secretKey = arguments!["secretKey"] as? String
                let secretId = arguments!["secretId"] as? String
                let fileName = arguments!["imageName"] as? String
                let region = arguments!["region"] as? String
                let subRegion = arguments!["subRegion"] as? String
                let imageUploadFolder = arguments!["imageUploadFolder"] as? String


          let credentialsProvider = AWSStaticCredentialsProvider(accessKey: secretKey!, secretKey: secretId!)
            print("uploadImageForRegion----")
          let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
          AWSServiceManager.default().defaultServiceConfiguration = configuration
              let contentTypeParam = arguments!["contentType"] as? String
//

                print("region" + region!)

                print("subregion " + subRegion!)
//                if(region != nil && subRegion != nil){
//                    initRegions(region: region!, subRegion: subRegion!)
//                }
//
//              let credentialsProvider = AWSCognitoCredentialsProvider(
//                  regionType: region1,
//                  identityPoolId: identity!)
//              let configuration = AWSServiceConfiguration(
//                  region: subRegion1,
//                  credentialsProvider: credentialsProvider)
              AWSServiceManager.default().defaultServiceConfiguration = configuration
//
//
                var imageAmazonUrl = false
                let fileUrl = NSURL(fileURLWithPath: imagePath!)
//
                let uploadRequest = AWSS3TransferManagerUploadRequest()
                uploadRequest?.bucket = bucket
                uploadRequest?.key = imageUploadFolder! + "/" + fileName!
//
//
              var contentType = "image/jpeg"
              if(contentTypeParam != nil &&
                  contentTypeParam!.count > 0){
                  contentType = contentTypeParam!
              }
//
              if(contentTypeParam == nil || contentTypeParam!.count == 0 &&  fileName!.contains(".")){
                             var index = fileName!.lastIndex(of: ".")
                             index = fileName!.index(index!, offsetBy: 1)
                             if(index != nil){
                                 let extention = String(fileName![index!...])
                                 print("extension"+extention);
                                 if(extention.lowercased().contains("png") ||
                                 extention.lowercased().contains("jpg") ||
                                     extention.lowercased().contains("jpeg") ){
                                     contentType = "image/"+extention
                                 }else{

                                  if(extention.lowercased().contains("pdf")){
                                      contentType = "application/pdf"
                                      }else{
                                      contentType = "application/*"
                                      }

                                 }

                             }
                         }

              uploadRequest?.contentType = contentType

                uploadRequest?.body = fileUrl as URL

                uploadRequest?.acl = .publicReadWrite

                AWSS3TransferManager.default().upload(uploadRequest!).continueWith { (task) -> AnyObject? in

                    if let error = task.error {
                        print("❌ Upload failed (\(error))")
                    }
//
//
                    if task.result != nil  {
//       return "https://"+BUCKET_NAME+"s3.amazonaws.com/"+key
                       imageAmazonUrl = true
                        print("✅ Upload successed (\(imageAmazonUrl))")
                    } else {
                        print("❌ Unexpected empty result.")

                    }
                    result(imageAmazonUrl)
                    return nil
                }
      }

      func deleteImage(_ call: FlutterMethodCall, result: @escaping FlutterResult){
         let arguments = call.arguments as? NSDictionary
         let bucket = arguments!["bucket"] as? String
         let secretKey = arguments!["secretKey"] as? String
         let secretId = arguments!["secretId"] as? String
         let fileName = arguments!["imageName"] as? String
         let region = arguments!["region"] as? String
         let subRegion = arguments!["subRegion"] as? String
         let imageUploadFolder = arguments!["imageUploadFolder"] as? String


         if(region != nil && subRegion != nil){
             initRegions(region: region!, subRegion: subRegion!)
         }

          let credentialsProvider = AWSStaticCredentialsProvider(accessKey: secretKey!, secretKey: secretId!)
            print("uploadImageForRegion----")
          let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
          AWSServiceManager.default().defaultServiceConfiguration = configuration


         AWSS3.register(with: configuration!, forKey: "defaultKey")
         let s3 = AWSS3.s3(forKey: "defaultKey")
         let deleteObjectRequest = AWSS3DeleteObjectRequest()
         deleteObjectRequest?.bucket = bucket // bucket name
         deleteObjectRequest?.key =  imageUploadFolder! + "/" + fileName! // File name
         s3.deleteObject(deleteObjectRequest!).continueWith { (task:AWSTask) -> AnyObject? in
             if let error = task.error {
                 print("Error occurred: \(error)")
                 result(false)
                 return nil
             }
             print("image deleted successfully.")
             result(true)
             return nil
         }

      }


      public func initRegions(region:String,subRegion:String){
          region1 = getRegion(name: region)
          subRegion1 = getRegion(name: subRegion)
      }

      public func getRegion( name:String ) -> AWSRegionType{
            let reg: String = (name as AnyObject).replacingOccurrences(of: "Regions.", with: "")
          switch reg {
                     case "Unknown":
                         return AWSRegionType.Unknown
                 case "US_EAST_1":
                     return AWSRegionType.USEast1
                 case "US_EAST_2":
                     return AWSRegionType.USEast2
                 case "US_WEST_1":
                     return AWSRegionType.USWest1
                 case "US_WEST_2":
                     return AWSRegionType.USWest2
                 case "EU_WEST_1":
                     return AWSRegionType.EUWest1
                 case "EU_WEST_2":
                     return AWSRegionType.EUWest2
                 case "EU_CENTRAL_1":
                     return AWSRegionType.EUCentral1
                 case "AP_SOUTHEAST_1":
                     return AWSRegionType.APSoutheast1
                 case "AP_NORTHEAST_1":
                     return AWSRegionType.APNortheast1
                 case "AP_NORTHEAST_2":
                     return AWSRegionType.APNortheast2
                 case "AP_SOUTHEAST_2":
                     return AWSRegionType.APSoutheast2
                 case "AP_SOUTH_1":
                     return AWSRegionType.APSouth1
                 case "CN_NORTH_1":
                     return AWSRegionType.CNNorth1
                 case "CA_CENTRAL_1":
                     return AWSRegionType.CACentral1
                 case "USGovWest1":
                     return AWSRegionType.USGovWest1
                 case "CN_NORTHWEST_1":
                     return AWSRegionType.CNNorthWest1
                 case "EU_WEST_3":
                     return AWSRegionType.EUWest3

                 default:
                     return AWSRegionType.Unknown
                 }

      }
}
