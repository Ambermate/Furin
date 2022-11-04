//
//  Tracking.swift
//  Furin
//
//  Created by Long Hai on 11/2/22.
//

import Foundation
import UIKit
import CoreLocation
import SwiftUI


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if NSString(string: UIDevice.current.systemVersion).doubleValue > 2 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let speed = locationManager.location?.speed else {return}
        Noti.speed = speed * 3600 / 1609.3

        print("check speed: \(Noti.speed)")
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.denied {
            locationManager.startUpdatingLocation()
        }
    }
    
}

struct Noti {
    static var speed: Double = 0.1
    static var notification: Bool = false
}
