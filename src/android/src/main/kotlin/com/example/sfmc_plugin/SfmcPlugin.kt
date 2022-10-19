package com.example.sfmc_plugin

import android.content.Context
import androidx.annotation.NonNull
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SfmcPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sfmc_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                // It is already initialized in BaseApplication onCreate method
                result.success(true)
            }
            "setContactKey" -> {
                var isOperationSuccessful: Boolean
                val contactKey = call.argument<String>("contactKey")
                if (contactKey == null || contactKey == "") {
                    result.error(
                        "Contact Key is not valid",
                        "Contact Key is not valid",
                        "Contact Key is not valid"
                    )
                    return
                }
                isOperationSuccessful = try {
                    SFMCSdk.requestSdk { sdk ->
                        sdk.identity.setProfileId(contactKey)
                    }
                    true
                } catch (e: RuntimeException) {
                    false
                }
                result.success(isOperationSuccessful)
            }
            "getContactKey" -> {
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
            }
            "addTag" -> {
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
            }
            "removeTag" -> {
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
            }
            "setProfileAttribute" -> {
                var isSuccessful: Boolean
                val attributeKey: String? = call.argument<String?>("key")
                val attributeValue: String? = call.argument<String?>("value")
                if (attributeKey == null || attributeKey == "") {
                    result.error("Attribute Key is not valid", "Attribute Key is not valid", "Attribute Key is not valid");
                    return
                }
                if (attributeValue == null || attributeValue == "") {
                    result.error("Attribute Value is not valid", "Attribute Value is not valid", "Attribute Value is not valid");
                    return
                }
                isSuccessful = try {
                    SFMCSdk.requestSdk { sdk ->
                        sdk.identity.setProfileAttribute(attributeKey, attributeValue)
                    }
                    true
                } catch (e: RuntimeException) {
                    false
                }
                result.success(isSuccessful)
            }
            "clearProfileAttribute" -> {
                var isSuccessful: Boolean
                val attributeKey: String? = call.argument<String?>("key")
                if (attributeKey == null || attributeKey == "") {
                    result.error("Attribute Key is not valid", "Attribute Key is not valid", "Attribute Key is not valid");
                    return
                }
                isSuccessful = try {
                    SFMCSdk.requestSdk { sdk ->
                        sdk.identity.clearProfileAttribute(attributeKey)
                    }
                    true
                } catch (e: RuntimeException) {
                    false
                }
                result.success(isSuccessful)
            }
            "setPushEnabled" -> {
                val enablePush: Boolean = call.argument<Boolean>("isEnabled") as Boolean
                if (enablePush) {
                    MarketingCloudSdk.requestSdk { sdk -> sdk.pushMessageManager.enablePush() }
                } else {
                    MarketingCloudSdk.requestSdk { sdk -> sdk.pushMessageManager.disablePush() }
                }
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}