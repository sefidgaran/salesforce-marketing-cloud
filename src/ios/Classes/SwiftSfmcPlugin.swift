import Flutter
import UIKit
import MarketingCloudSDK
import Foundation

public class SwiftSfmcPlugin: NSObject, FlutterPlugin, MarketingCloudSDKURLHandlingDelegate, MarketingCloudSDKEventDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sfmc_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSfmcPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "initialize" {
            var isInitSuccessful = false;
            guard let args = call.arguments as? [String : Any] else {return}
            let appId = args["appId"] as? String
            let accessToken = args["accessToken"] as? String
            let mid = args["mid"] as? String
            let sfmcURL = args["sfmcURL"] as? String
            let locationEnabled = args["locationEnabled"] as? Bool
            let inboxEnabled = args["inboxEnabled"] as? Bool
            let analyticsEnabled = args["analyticsEnabled"] as? Bool
            let delayRegistration = args["delayRegistration"] as? Bool
            
            if appId == nil || accessToken == nil || mid == nil || sfmcURL == nil {
                result(false)
                return
            }
            
            setupSFMC(
                appId: appId!,
                accessToken: accessToken!,
                mid: mid!,
                sfmcURL: sfmcURL!,
                locationEnabled: locationEnabled,
                inboxEnabled: inboxEnabled,
                analyticsEnabled: analyticsEnabled,
                delayRegistration: delayRegistration,
                onDone: { sfmcResult, message, code in
                    if (sfmcResult) {
                        isInitSuccessful = true
                    } else {
                        isInitSuccessful = false
                        NSLog(message!)
                    }
                    result(isInitSuccessful)
                })
        }else if call.method == "setContactKey" {
            guard let args = call.arguments as? [String : Any] else {return}
            let cKey = args["contactKey"] as! String?
            if cKey == nil || cKey == "" {
                result(false)
                return
            }
            result(setContactKey(contactKey: cKey!))
        }else if call.method == "getContactKey" {
            let cKey : String? = getContactKey()
            
            result(cKey)
        }else if call.method == "addTag" {
            
            guard let args = call.arguments as? [String : Any] else {return}
            let tag = args["tag"] as! String?
            if tag == nil {
                result(false)
                return
            }
            
            result(setTag(tag: tag!))
        } else if call.method == "removeTag" {
            guard let args = call.arguments as? [String : Any] else {return}
            let tag = args["tag"] as! String?
            if tag == nil {
                result(false)
                return
            }
            result(removeTag(tag:tag!))
        }
    }
    
    public func setupSFMC(appId: String, accessToken: String, mid: String, sfmcURL: String, locationEnabled: Bool?, inboxEnabled: Bool?, analyticsEnabled: Bool?, delayRegistration: Bool?, onDone: (_ result: Bool, _ message: String?, _ code: Int?) -> Void) {
        var success : Bool = false
        MarketingCloudSDK.sharedInstance().sfmc_tearDown()
        
        let builder = MarketingCloudSDKConfigBuilder()
            .sfmc_setApplicationId(appId)
            .sfmc_setAccessToken(accessToken)
            .sfmc_setMarketingCloudServerUrl(sfmcURL)
            .sfmc_setMid(mid)
            .sfmc_setDelayRegistration(untilContactKeyIsSet: (delayRegistration ?? false) as NSNumber)
            .sfmc_setInboxEnabled((inboxEnabled ?? true) as NSNumber)
            .sfmc_setLocationEnabled((locationEnabled ?? true)  as NSNumber)
            .sfmc_setAnalyticsEnabled((analyticsEnabled ?? true)  as NSNumber)
            .sfmc_build()!
        
        MarketingCloudSDK.sharedInstance().sfmc_setURLHandlingDelegate(self)
        MarketingCloudSDK.sharedInstance().sfmc_setEventDelegate(self)
        
        do {
            try MarketingCloudSDK.sharedInstance().sfmc_configure(with:builder)
            success = true;
            onDone(true, nil, nil);
        } catch let error as NSError {
            
            onDone(false, error.localizedDescription, error.code);
        }
        
        if success == true {
            // Handle URL stuff
            
            #if DEBUG
            MarketingCloudSDK.sharedInstance().sfmc_setDebugLoggingEnabled(true)
            #endif
            MarketingCloudSDK.sharedInstance().sfmc_setURLHandlingDelegate(self)
            
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
                    // In this exmple, the AppDelegate class adheres to the protocol (see below)
                    // and handles Notification Center delegate methods from iOS.
                    UNUserNotificationCenter.current().delegate = self
                    
                    // Request authorization from the user for push notification alerts.
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                        if error == nil {
                            if granted == true {
                                // Your application may want to do something specific if the user has granted authorization
                                // for the notification types specified; it would be done here.
                                print(MarketingCloudSDK.sharedInstance().sfmc_deviceToken() ?? "error: no token - was UIApplication.shared.registerForRemoteNotifications() called?")
                            }
                        }
                    })
                }
                // In any case, your application should register for remote notifications *each time* your application
                // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.
                
                // Registering in this manner does *not* mean that a user will see a notification - it only means
                // that the application will receive a unique push token from iOS.
                UIApplication.shared.registerForRemoteNotifications()
                
            }}
    }
    
    func setContactKey(contactKey: String) -> Bool? {
        MarketingCloudSDK.sharedInstance().sfmc_setContactKey(contactKey)
        return true
    }
    
    func getContactKey()-> String?{
        let contactKey: String? = MarketingCloudSDK.sharedInstance().sfmc_contactKey()
        return contactKey
    }
    
    func setTag(tag: String) -> Bool {
        MarketingCloudSDK.sharedInstance().sfmc_addTag(tag)
        return true
    }
    func removeTag(tag: String) -> Bool {
        MarketingCloudSDK.sharedInstance().sfmc_removeTag(tag)
        return true
    }
    
    /*
     * URL Handling
     */
    
    public func sfmc_handle(_ url: URL, type: String) {
        if UIApplication.shared.canOpenURL(url) == true {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("url \(url) opened successfully")
                    } else {
                        print("url \(url) could not be opened")
                    }
                })
            } else {
                if UIApplication.shared.openURL(url) == true {
                    print("url \(url) opened successfully")
                } else {
                    print("url \(url) could not be opened")
                }
            }
        }
    }
    
    /*
     * IN-APP Messaging
     */
    public func sfmc_didShow(inAppMessage message: [AnyHashable : Any]) {
        // message shown
    }
    
    public func sfmc_didClose(inAppMessage message: [AnyHashable : Any]) {
        // message closed
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MarketingCloudSDK.sharedInstance().sfmc_setDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

    /** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. **/
    @nonobjc public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationUserInfo(userInfo)
        completionHandler(.newData)
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Required: tell the MarketingCloudSDK about the notification. This will collect MobilePush analytics
        // and process the notification on behalf of your application.
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(response.notification.request)
        completionHandler()
    }

    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
