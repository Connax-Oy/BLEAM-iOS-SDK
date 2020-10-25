//
//  AppController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import UIKit

@main
final class AppController: NSObject, UIApplicationDelegate, BLEAM.Delegate {
   var window: UIWindow?

   // MARK: - App Launch

   func application(
      _ application: UIApplication,
      willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
#if DEBUG
      let appID = "08b3a9ca-5a65-4e1b-a590-7ccb154d0a00"
      let appSecret = "Kn7lDKNQJJIdUoZvDOYXL5SFXyNP7shu3PjuCxRcy0IclyrY11v11FbeMbtl9s1O"
#else
      let appID = "f03b4cf4-c55d-44cc-b5d1-f9dca2ae5585"
      let appSecret = "d8jFmUWR188VD4BKoKt8rTIYvd2Y2OfiElL4vNltbeDe5eLRCqian1EYbn0xqqcW"
#endif

      let configuration = Configuration(appID: appID, appSecret: appSecret)
      let sdk = SDK(configuration: configuration, delegate: self)

      sdk.processLaunchOptions(launchOptions)

      if #available(iOS 13.0, *) {
         sdk.registerForBackgroundSynchronization()
      } else if application.backgroundRefreshStatus == .available {
         application.setMinimumBackgroundFetchInterval(1.days)
      }

      SDK.setShared(sdk)

      return true
   }

   // MARK: - App Lifecycle

   func applicationDidBecomeActive(_ application: UIApplication) {
      if #available(iOS 13.0, *) {
         let sdk = SDK.shared()
         sdk.startBackgroundSynchronization()
      }
   }

   // MARK: - Background App Refresh

   func application(
      _ application: UIApplication,
      performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
   ) {
      let sdk = SDK.shared()
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
}
