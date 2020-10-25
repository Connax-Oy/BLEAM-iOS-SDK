//
//  LogsStorageLogger.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import UIKit

final class LogsStorageLogger: Logger {
   private unowned let logsStorage: LogsStorage = .shared

   // MARK: - Logger

   func log(_ level: LogLevel, _ message: String, _ tag: String?) {
      let color: UIColor
      switch level {
         case .debug:
            color = .darkGray
         case .error:
            color = .systemRed
         case .info:
            color = .darkText
         case .warning:
            color = .systemYellow
      }

      logsStorage.writeLog(message, color: color)
   }
}
