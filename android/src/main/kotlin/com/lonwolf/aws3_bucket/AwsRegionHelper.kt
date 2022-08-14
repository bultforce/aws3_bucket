package com.lonwolf.aws3_bucket

import android.content.Context
import android.os.AsyncTask
import android.util.Log
import com.amazonaws.auth.AWSCredentials
import com.amazonaws.auth.BasicAWSCredentials
import com.amazonaws.auth.CognitoCachingCredentialsProvider
import com.amazonaws.auth.CognitoCredentialsProvider
import com.amazonaws.mobile.config.AWSConfiguration
import com.amazonaws.mobileconnectors.s3.transferutility.*
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions
import com.amazonaws.services.s3.AmazonS3Client
import com.amazonaws.services.s3.model.S3ObjectSummary
import java.io.File
import java.io.UnsupportedEncodingException

class AwsRegionHelper(private val context: Context,
                      private val BUCKET_NAME: String,
                      private val SECRET_KEY: String,
                      private val SECRET_ID: String,
                      private val REGION: String, private val SUB_REGION: String)
{

    private var transferUtility: TransferUtility
    private var region1:Regions = Regions.DEFAULT_REGION
    private var subRegion1:Regions = Regions.DEFAULT_REGION


    init {
        initRegion()
        transferUtility =  getTransferUtility()
    }

    private fun getTransferUtility():TransferUtility{
        //val awsConfiguration = AWSConfiguration(context)
        //awsConfiguration.
        val amazonS3Client = getAmazonS3Client()
        TransferNetworkLossHandler.getInstance(context.applicationContext)
        val transferOptions = TransferUtilityOptions()
        transferOptions.transferThreadPoolSize = 18

        return  TransferUtility.builder()
            .s3Client(amazonS3Client).
            transferUtilityOptions(transferOptions)
            .defaultBucket(BUCKET_NAME)
            .context(context)
            .build()
    }


    private fun getUploadedUrl(key: String?): String {
        return "https://"+BUCKET_NAME+"s3.amazonaws.com/"+key
        //return  ""+key
    }

    private fun getAmazonS3Client():AmazonS3Client{
//        val credentialsProvider = CognitoCachingCredentialsProvider(context, IDENTITY_POOL_ID, region1)
        val aws =BasicAWSCredentials(SECRET_KEY, SECRET_ID);
        print("--------------------------------------------------------\n")
        print("getAmazonS3Client\n")
        print(SECRET_KEY)
        print("getAmazonS3Client\n")
        print(SECRET_ID)
        print(subRegion1)
//        print(IDENTITY_POOL_ID+"\n")
        return AmazonS3Client(aws, com.amazonaws.regions.Region.getRegion(
            Regions.US_EAST_1
        ))
    }

    private fun initRegion(){

        region1 = RegionHelper(REGION).getRegionName()
        subRegion1 = RegionHelper(SUB_REGION).getRegionName()

    }

    @Throws(UnsupportedEncodingException::class)
    fun deleteImage(imageName: String,folderToUploadTo: String?, onUploadCompleteListener: OnUploadCompleteListener): String {

        initRegion()

        TransferNetworkLossHandler.getInstance(context.applicationContext)

        var key = imageName

        if(folderToUploadTo != null){
            key = if(folderToUploadTo.endsWith("/")){
                folderToUploadTo + imageName
            }else{
                "$folderToUploadTo/$imageName"
            }

        }

        val amazonS3Client =  getAmazonS3Client()

        Thread( Runnable{
            amazonS3Client.deleteObject(BUCKET_NAME, key)
        }).start()
        onUploadCompleteListener.onUploadComplete("Success")
        return imageName

    }

    @Throws(UnsupportedEncodingException::class)
    fun uploadImage(image: File, imageName: String, folderToUploadTo:String?, onUploadCompleteListener: OnUploadCompleteListener): String {

        initRegion()

        TransferNetworkLossHandler.getInstance(context.applicationContext)

        var key = imageName

        if(folderToUploadTo != null){
            key = if(folderToUploadTo.endsWith("/")){
                folderToUploadTo + imageName
            }else{
                "$folderToUploadTo/$imageName"
            }

        }

        val transferObserver = transferUtility.upload(BUCKET_NAME, key, image)

        transferObserver.setTransferListener(object : TransferListener {
            override fun onStateChanged(id: Int, state: TransferState) {
                if (state == TransferState.COMPLETED) {
                    onUploadCompleteListener.onUploadComplete(getUploadedUrl(key))
                }
                if (state == TransferState.FAILED ||  state == TransferState.WAITING_FOR_NETWORK) {
                    onUploadCompleteListener.onFailed()
                }
            }

            override fun onProgressChanged(id: Int, bytesCurrent: Long, bytesTotal: Long) {}
            override fun onError(id: Int, ex: Exception) {
                onUploadCompleteListener.onFailed()
                Log.e(TAG, "error in upload id [ " + id + " ] : " + ex.message)

            }
        })
        return getUploadedUrl(key)
    }


    interface OnUploadCompleteListener {
        fun onUploadComplete(imageUrl: String)
        fun onFailed()
    }



    companion object {
        private val TAG = AwsRegionHelper::class.java.simpleName
        private const val URL_TEMPLATE = "https://s3.amazonaws.com/%s/%s"
    }



}
