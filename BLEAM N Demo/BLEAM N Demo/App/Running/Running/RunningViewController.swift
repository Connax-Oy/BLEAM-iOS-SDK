//
//  RunningViewController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import UIKit

final class RunningViewController: UIViewController, LogsStorageDelegate {
   private unowned let sdk: SDK = .shared()
   private unowned let logsStorage: LogsStorage = .shared

   @IBOutlet
   private var startStopMonitoringButton: UIButton!

   @IBOutlet
   private var logsTextView: UITextView!

   // MARK: - View Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()

      logsStorage.delegate = self

      logsTextView.textContainerInset = .zero
      logsTextView.textContainer.lineFragmentPadding = 0

      if sdk.isMonitoringActive {
         startStopMonitoringButton.setTitle("Stop Monitoring", for: .normal)
      }
   }

   // MARK: - Actions - IB

   @IBAction
   private func startStopMonitoringButtonDidTouchUpInside() {
      if sdk.isMonitoringActive {
         sdk.stopMonitoring()
         startStopMonitoringButton.setTitle("Start Monitoring", for: .normal)
         return
      }

      sdk.startMonitoring { [self] result in
         switch result {
            case .success:
               startStopMonitoringButton.setTitle("Stop Monitoring", for: .normal)
            case let .failure(error):
               showAlert(for: error)
         }
      }
   }

   @IBAction
   private func startOneOffByLocationButtonDidTouchUpInside() { }

   @IBAction
   private func startOneOffByExternalIDButtonDidTouchUpInside() {
      requestExternalID { externalID in
         print(externalID)
      }
   }

   @IBAction
   private func clearLogsButtonDidTouchUpInside() {
      logsTextView.text = nil
      logsStorage.clearLogs()
   }

   // MARK: - LogsStorageDelegate

   func logsStorageDidChange(_ storage: LogsStorage) {
      logsTextView.attributedText = storage.string
   }

   // MARK: - Private - Helpers

   private func showAlert(for error: Error) {
      let controller = UIAlertController(
         title: "Can't run BLEAM",
         message: "Something went wrong while running: \(error)",
         preferredStyle: .alert
      )
      controller.addAction(UIAlertAction(title: "Close", style: .cancel))
      present(controller, animated: true)
   }

   private func requestExternalID(completion: @escaping (String) -> Void) {
      let controller = UIAlertController(
         title: "Enter External ID of Geofence",
         message: nil,
         preferredStyle: .alert
      )
      controller.addTextField {
         $0.placeholder = "External ID"
      }
      controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      controller.addAction(UIAlertAction(title: "Start", style: .default) { [unowned controller] action in
         if let externalID = controller.textFields?.first?.text, !externalID.isEmpty {
            completion(externalID)
         }
      })
      present(controller, animated: true)
   }
}
