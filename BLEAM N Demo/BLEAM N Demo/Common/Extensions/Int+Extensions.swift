//
//  Int+Extensions.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import Foundation

extension Int {
   var seconds: TimeInterval {
      TimeInterval(self)
   }

   var minutes: TimeInterval {
      60.0 * seconds
   }

   var hours: TimeInterval {
      60.0 * minutes
   }

   var days: TimeInterval {
      24.0 * hours
   }
}
