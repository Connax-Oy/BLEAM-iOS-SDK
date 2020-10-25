//
//  AppController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import UIKit

@main
final class AppController: NSObject, UIApplicationDelegate {
   var window: UIWindow?

   // MARK: - UIApplicationDelegate

   func application(
      _ application: UIApplication,
      willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
      return true
   }
}
