//
//  AppController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import UIKit
import UserNotifications

@main
final class AppController: NSObject, UIApplicationDelegate, BLEAM.Delegate {
   var window: UIWindow?

   // MARK: - App Launch

   func application(
      _ application: UIApplication,
      willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
      let configuration = Configuration(
         appID: ENV.appID,
         appSecret: ENV.appSecret,
         useDebugURL: ENV.useDebugURL
      )
      configuration.logger = LogsStorageLogger()

      let sdk = SDK(configuration: configuration, delegate: self)
      SDK.setShared(sdk)

      sdk.processLaunchOptions(launchOptions)

      if #available(iOS 13.0, *) {
         sdk.registerForBackgroundSynchronization()
      } else if application.backgroundRefreshStatus == .available {
         application.setMinimumBackgroundFetchInterval(1.days)
      }

      let options: UNAuthorizationOptions = [.alert, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in }

      return true
   }

   // MARK: - App Lifecycle

   func applicationDidBecomeActive(_ application: UIApplication) {
      if #available(iOS 13.0, *) {
         let sdk: SDK = .shared()
         sdk.startBackgroundSynchronization()
      }
   }

   // MARK: - Background App Refresh

   func application(
      _ application: UIApplication,
      performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
   ) {
      let sdk: SDK = .shared()
      sdk.synchronizeGeofences { result in
         switch result {
            case .success:
               completionHandler(.newData)
            case .failure:
               completionHandler(.failed)
         }
      }
   }

   // MARK: - BLEAM.Delegate

   func bleamSDK(_ sdk: SDK, didPredict position: Int, in geofence: Geofence) { }

   func bleamSDK(_ sdk: SDK, didEnter geofence: Geofence) {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
         guard settings.authorizationStatus == .authorized else {
            return
         }

         let content = UNMutableNotificationContent()
         content.title = "You Entered Geofence"
         content.body = "Info: \(geofence)"
         content.sound = .pristine
         content.badge = 0

         let request = UNNotificationRequest(
            identifier: "io.connax.geofencesMonitoring",
            content: content,
            trigger: nil
         )
         UNUserNotificationCenter.current().add(request)
      }
   }

   func bleamSDK(_ sdk: SDK, didExit geofence: Geofence) {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
         guard settings.authorizationStatus == .authorized else {
            return
         }

         let content = UNMutableNotificationContent()
         content.title = "You Exited Geofence"
         content.body = "Info: \(geofence)"
         content.sound = .pristine
         content.badge = 0

         let request = UNNotificationRequest(
            identifier: "io.connax.geofencesMonitoring",
            content: content,
            trigger: nil
         )
         UNUserNotificationCenter.current().add(request)
      }
   }
}
