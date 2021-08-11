//
//  ViewController.swift
//  MapKitInSwift
//
//  Created by Odenza on 11/8/2564 BE.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    var message = ""
    
    var alertView: UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
        
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Show alert letting the user know they have to turn it on.
            present(alertView, animated: true, completion: nil)
        }
    
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedWhenInUse:
            print("check location Auth: authorizedWhenInUse")

            mapView.showsUserLocation = true
            centerOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            print("check location Auth: authorizedAlways")
            break
        case .notDetermined:
            print("check location Auth: notDetermined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show alert
            print("check location Auth: restricted")
            break
        case .denied:
            //show alert
            print("check location Auth: denied")
            
            DispatchQueue.main.async {
                self.message = "Please allow the app to access your location."
                self.present(self.alertView, animated: true, completion: nil)
            }
            
            break
        @unknown default:
            //show alert
            print("check location Auth: unknown default")
            break
        }
    }
    
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }
    
    func centerOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            self.mapView.setRegion(region, animated: true)
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
//        switch manager.authorizationStatus {
//        case .authorizedAlways , .authorizedWhenInUse:
//            break
//        case .notDetermined , .denied , .restricted:
//            break
//        default:
//            break
//        }
//
//    }
}

