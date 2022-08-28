package com.example.sfmc_plugin

import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.notifications.NotificationManager
import java.util.*

class MainApplication : BaseApplication() {
    override val configBuilder: MarketingCloudConfig.Builder
        get() = MarketingCloudConfig.builder().apply {
            setApplicationId(BuildConfig.MC_APP_ID)
            setAccessToken(BuildConfig.MC_ACCESS_TOKEN)
            setSenderId(BuildConfig.MC_SENDER_ID)
            setMid(BuildConfig.MC_MID)
            setMarketingCloudServerUrl(BuildConfig.MC_SERVER_URL)
            setDelayRegistrationUntilContactKeyIsSet(true)
            setUrlHandler(this@MainApplication)
            setNotificationCustomizationOptions(
                NotificationCustomizationOptions.create { context, notificationMessage ->
                    val builder = NotificationManager.getDefaultNotificationBuilder(
                        context,
                        notificationMessage,
                        NotificationManager.createDefaultNotificationChannel(context),
                        R.drawable.ic_notification
                    )
                    builder.setContentIntent(
                        PendingIntent.getActivity(
                            context,
                            Random().nextInt(),
                            Intent(Intent.ACTION_VIEW, Uri.parse(notificationMessage.url)),
                            PendingIntent.FLAG_IMMUTABLE
                        ),
                    )
                    builder.setAutoCancel(true)
                }
            )
        }
}