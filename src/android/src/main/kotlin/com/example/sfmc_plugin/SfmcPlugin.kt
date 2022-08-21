package com.example.sfmc_plugin

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.salesforce.marketingcloud.MCLogListener
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.UrlHandler
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.notifications.NotificationManager
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.util.*

class SfmcPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private fun saveInitSdkCache(
        appId: String,
        accessToken: String,
        senderId: String,
        mid: String,
        sfmcUrl: String
    ) {

        val file: File = File(context.cacheDir.path, "/" + "sdk_cache.txt")
        val fw = FileWriter(file.absoluteFile)
        val bw = BufferedWriter(fw)

        bw.write(appId)
        bw.newLine()
        bw.write(accessToken)
        bw.newLine()
        bw.write(mid)
        bw.newLine()
        bw.write(sfmcUrl)
        bw.newLine()
        bw.write(senderId)

        bw.close()
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sfmc_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    private fun initSDK(
        appId: String,
        accessToken: String,
        senderId: String,
        mid: String,
        sfmcUrl: String,
    ): Boolean {

        var isInitialized: Boolean = false
        if (BuildConfig.DEBUG) {
            MarketingCloudSdk.setLogLevel(MCLogListener.VERBOSE)
            MarketingCloudSdk.setLogListener(MCLogListener.AndroidLogListener())
        }

        try {
            SFMCSdk.configure(context, SFMCSdkModuleConfig.build {
                pushModuleConfig = MarketingCloudConfig.builder().apply {
                    setApplicationId(appId)
                    setAccessToken(accessToken)
                    setSenderId(senderId)
                    setMarketingCloudServerUrl(sfmcUrl)
                    setMid(mid)
                    setDelayRegistrationUntilContactKeyIsSet(true)
                    setNotificationCustomizationOptions(
                        NotificationCustomizationOptions.create { context, notificationMessage ->
                            val builder = NotificationManager.getDefaultNotificationBuilder(
                                context,
                                notificationMessage,
                                NotificationManager.createDefaultNotificationChannel(context),
                                R.drawable.ic_notification_icon
                            )

                            builder.setContentIntent(
                                PendingIntent.getActivity(
                                    context,
                                    Random().nextInt(),
                                    Intent(Intent.ACTION_VIEW, Uri.parse(notificationMessage.url)),
                                    PendingIntent.FLAG_UPDATE_CURRENT
                                ),
                            )
                            builder.setAutoCancel(true)
                        }
                    )
                    setUrlHandler(UrlHandler { context, url, _ ->
                        PendingIntent.getActivity(
                            context,
                            Random().nextInt(),
                            Intent(Intent.ACTION_VIEW, Uri.parse(url)),
                            PendingIntent.FLAG_UPDATE_CURRENT
                        )
                    })

                }.build(context)
            }) {
            }
            isInitialized = true
        } catch (e: RuntimeException) {
            Log.d("Error ->", e.toString())
            isInitialized = false
        }
        return isInitialized
    }


    override fun onMethodCall(call: MethodCall, result: Result) {

        if (call.method == "initialize") {
            val appId: String = call.argument<String>("appId") as String
            val accessToken: String = call.argument<String?>("accessToken") as String
            val mid: String = call.argument<String?>("mid") as String
            val senderId: String = call.argument<String?>("senderId") as String
            val sfmcURL: String = call.argument<String?>("sfmcURL") as String

            saveInitSdkCache(appId, accessToken, senderId, mid, sfmcURL)
            val isInitializationSuccessful: Boolean =
                initSDK(appId, accessToken, senderId, mid, sfmcURL)

            result.success(isInitializationSuccessful)

        } else if (call.method == "setContactKey") {

            var isOperationSuccessful: Boolean = false;
            val contactKey = call.argument<String>("contactKey")

            if (contactKey == null || contactKey == "") {
                result.error(
                    "Contact Key is not valid",
                    "Contact Key is not valid",
                    "Contact Key is not valid"
                );
                return
            }

            try {
                SFMCSdk.requestSdk { sdk ->
                    sdk.identity.setProfileId(contactKey)
                }
                isOperationSuccessful = true
            } catch (e: RuntimeException) {
                isOperationSuccessful = false
            }

            result.success(isOperationSuccessful)
        } else if (call.method == "getContactKey") {

            var key: String? = null

            try {
                SFMCSdk.requestSdk { sdk ->
                    sdk.mp {
                        var contactKey = it.moduleIdentity.profileId
                        key = contactKey
                        result.success(key)
                    }
                }
            } catch (e: RuntimeException) {
                result.success(key)
            }

        } else if (call.method == "addTag") {
            val tagToAdd: String? = call.argument<String?>("tag")

            if (tagToAdd == null || tagToAdd == "") {
                result.error("Tag is not valid", "Tag is not valid", "Tag is not valid");
                return
            }

            try {
                SFMCSdk.requestSdk { sdk ->
                    sdk.mp {
                        it.registrationManager.edit().run {
                            addTags(tagToAdd)
                            commit()
                            result.success(true)
                        }
                    }
                }
            } catch (e: RuntimeException) {
                result.error(e.toString(), e.toString(), e.toString())
            }
        } else if (call.method == "removeTag") {
            val tagToRemove: String? = call.argument<String?>("tag")

            if (tagToRemove == null || tagToRemove == "") {
                result.error("Tag is not valid", "Tag is not valid", "Tag is not valid");
                return
            }

            try {
                SFMCSdk.requestSdk { sdk ->
                    sdk.mp {
                        it.registrationManager.edit().run {
                            removeTags(tagToRemove)
                            commit()
                            result.success(true)
                        }
                    }
                }
            } catch (e: RuntimeException) {
                result.error(e.toString(), e.toString(), e.toString())
            }
        } else if (call.method == "setPushEnabled") {
            val enablePush: Boolean = call.argument<Boolean>("isEnabled") as Boolean
            if (enablePush) {
                MarketingCloudSdk.requestSdk { sdk -> sdk.pushMessageManager.enablePush() }
            } else {
                MarketingCloudSdk.requestSdk { sdk -> sdk.pushMessageManager.disablePush() }
            }
            result.success(true)
        } else {
            result.notImplemented()
        }
    }
}


