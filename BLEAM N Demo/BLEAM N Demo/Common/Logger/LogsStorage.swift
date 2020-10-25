//
//  LogsStorage.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import UIKit

protocol LogsStorageDelegate: AnyObject {
   func logsStorageDidChange(_ storage: LogsStorage)
}

final class LogsStorage {
   static let shared = LogsStorage()

   weak var delegate: LogsStorageDelegate?

   private let lockingQueue = DispatchQueue(label: "io.connax.BLEAM-N-Demo.lockQueue")
   private var logsString = NSMutableAttributedString()

   // MARK: - Logs Accessing

   var string: NSAttributedString {
      NSAttributedString(attributedString: logsString)
   }

   // MARK: - Writing Logs

   func writeLog(_ log: String, color: UIColor) {
      lockingQueue.async { [self] in
         let font: UIFont = .systemFont(ofSize: 12.0)
         let message = NSAttributedString(
            string: log,
            attributes: [.font: font, .foregroundColor: color]
         )
         logsString.append(message)
         logsString.append(NSAttributedString(string: "\n"))
         DispatchQueue.main.async {
            delegate?.logsStorageDidChange(self)
         }
      }
   }

   // MARK: - Clear Logs

   func clearLogs() {
      lockingQueue.async { [self] in
         logsString = NSMutableAttributedString()
         DispatchQueue.main.async {
            delegate?.logsStorageDidChange(self)
         }
      }
   }
}
