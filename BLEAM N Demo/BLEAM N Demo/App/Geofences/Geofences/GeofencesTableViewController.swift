//
//  GeofencesTableViewController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import UIKit

final class GeofencesTableViewController: UITableViewController {
   private unowned let sdk: SDK = .shared()
   private var geofences: [Geofence] = []

   // MARK: - View Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()

      fetchSynchronizedGeofences()
   }

   // MARK: - Actions - IB

   @IBAction
   private func refreshControlDidChangeValue() {
      synchronizeGeofences()
   }

   // MARK: - UITableViewDataSource

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      geofences.count
   }

   override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
   ) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "GeofenceCell", for: indexPath)
      let geofence = geofences[indexPath.row]
      cell.textLabel?.text = geofence.externalID
      return cell
   }

   // MARK: - UITableViewDelegate

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let geofence = geofences[indexPath.row]
      performSegue(withIdentifier: Segues.toOverviewGeofence, sender: geofence)
   }

   // MARK: - Navigation

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)

      if
         let controller = segue.destination as? OverviewGeofenceViewController,
         let geofence = sender as? Geofence
      {
         controller.geofence = geofence
      }
   }

   // MARK: - Private - Helpers

   private func synchronizeGeofences() {
      sdk.synchronizeGeofences { [self] result in
         refreshControl?.endRefreshing()

         switch result {
            case .success:
               fetchSynchronizedGeofences()
            case let .failure(error):
               showAlert(for: error)
         }
      }
   }

   private func fetchSynchronizedGeofences() {
      sdk.synchronizedGeofences { [self] result in
         switch result {
            case let .success(geofences):
               self.geofences = geofences
               tableView.reloadData()
            case let .failure(error):
               showAlert(for: error)
         }
      }
   }

   private func showAlert(for error: Error) {
      let controller = UIAlertController(
         title: "Can't fetch geofences",
         message: "Something went wrong while fetching geofences: \(error)",
         preferredStyle: .alert
      )
      controller.addAction(UIAlertAction(title: "Close", style: .cancel))
      present(controller, animated: true)
   }
}
