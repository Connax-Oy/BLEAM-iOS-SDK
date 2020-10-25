//
//  OverviewGeofenceViewController.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

import BLEAM
import MapKit
import UIKit

final class OverviewGeofenceViewController: UIViewController, MKMapViewDelegate {
   var geofence: Geofence!

   @IBOutlet
   private var mapView: MKMapView!

   @IBOutlet
   private var idValueLabel: UILabel!

   @IBOutlet
   private var externalIDValueLabel: UILabel!

   @IBOutlet
   private var rootIDValueLabel: UILabel!

   @IBOutlet
   private var radiusValueLabel: UILabel!

   // MARK: - View Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()

      mapView.layer.cornerRadius = 12.0

      let center = CLLocationCoordinate2D(latitude: geofence.lat, longitude: geofence.lng)
      let geofenceCircle = MKCircle(center: center, radius: geofence.radius)
      mapView.addOverlay(geofenceCircle)

      let geofenceRegion = MKCoordinateRegion(
         center: center,
         latitudinalMeters: geofence.radius * 3.0,
         longitudinalMeters: geofence.radius * 3.0
      )
      mapView.setRegion(geofenceRegion, animated: false)

      idValueLabel.text = geofence.id
      externalIDValueLabel.text = geofence.externalID
      rootIDValueLabel.text = geofence.rootID
      radiusValueLabel.text = String(format: "%.2f", geofence.radius)
   }

   // MARK: - MKMapViewDelegate

   func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKCircleRenderer(overlay: overlay)
      renderer.strokeColor = .systemBlue
      renderer.lineWidth = 2.0
      renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)
      return renderer
   }
}
