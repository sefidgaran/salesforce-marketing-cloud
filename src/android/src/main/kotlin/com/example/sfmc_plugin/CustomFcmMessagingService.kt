package com.example.sfmc_plugin

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.os.PowerManager.PARTIAL_WAKE_LOCK
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.UrlHandler
import com.salesforce.marketingcloud.messages.push.PushMessageManager
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.notifications.NotificationManager
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk.Companion.configure
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import kotlinx.coroutines.runBlocking
import java.io.File
import java.util.*


private fun getInitSDKCache(path: String): List<String> {
    val file = File(path, "/" + "sdk_cache.txt")
    val bufferedReader = file.bufferedReader()
    val texts: List<String> = bufferedReader.readLines()
    bufferedReader.close()

    return texts
}


class CustomFcmMessagingService : FirebaseMessagingService() {
    @SuppressLint("InvalidWakeLockTag")
    override fun onMessageReceived(message: RemoteMessage) {
        val pm = this.getSystemService(Context.POWER_SERVICE) as PowerManager
        runBlocking {
            val isScreenOn = pm.isScreenOn
            if (!isScreenOn) {
                val wl: PowerManager.WakeLock? = pm.newWakeLock(
                    PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP or PowerManager.ON_AFTER_RELEASE,
                    "MyLock"
                )
                wl?.acquire(10000)
                val wlCpu: PowerManager.WakeLock? =
                    pm.newWakeLock(PARTIAL_WAKE_LOCK, "MyCpuLock")
                wlCpu?.acquire(10000)
            }
        }
        runBlocking { initSDK() }
        if (PushMessageManager.isMarketingCloudPush(message)) {
            SFMCSdk.requestSdk { sdk ->
                sdk.mp {
                    it.pushMessageManager.handleMessage(message)
                }
            }
        }
    }

    override fun onNewToken(token: String) {
        runBlocking { initSDK() }
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                it.pushMessageManager.setPushToken(token)
            }
        }
    }

    private fun initSDK() {
        val context = this
        val texts: List<String>
        runBlocking { texts = getInitSDKCache(context.cacheDir.path) }
        val appId: String = texts[0]
        val accessToken: String = texts[1]
        val mid: String = texts[2]
        val url: String = texts[3]

        try {
            configure(this, SFMCSdkModuleConfig.build {
                pushModuleConfig = MarketingCloudConfig.builder().apply {
                    setApplicationId(appId)
                    setAccessToken(accessToken)
                    setMarketingCloudServerUrl(url)
                    setMid(mid)
                    // Not setting the sender id signals to the SDK that it will be handling the push token
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
        } catch (e: RuntimeException) {
        }
    }
}