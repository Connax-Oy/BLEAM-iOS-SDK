//
//  UNNotificationSound+Extensions.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import UserNotifications

extension UNNotificationSound {
   static var pristine: UNNotificationSound {
      UNNotificationSound(named: UNNotificationSoundName("Pristine.caf"))
   }
}
