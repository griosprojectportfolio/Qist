//
//  QistLocationManager.swift
//  Qist
//
//  Created by GrepRuby3 on 14/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreLocation

protocol locationAuthorizationDelegate {
    func getLocationAuthorizationMessage(message:String)
}

class QistLocationManager : NSObject , CLLocationManagerDelegate {
    
    var delegate: locationAuthorizationDelegate?
    var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var dictAddress : NSDictionary! = NSDictionary()
    
    
    // MARK: - Singleton manager
    class var sharedManager: QistLocationManager {
        struct Singleton {
            static let instance = QistLocationManager()
        }
        return Singleton.instance
    }
    
    
    // MARK: - Location Manager Initialize method
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    // MARK: - Location Manager delegate method
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        if let er : NSError = error {
            print(er.description)
        }else {
            if (seenError == false) {
                seenError = true
                print(error, terminator: "")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            self.currentLocation = locationObj.coordinate
            self.locationManager.stopUpdatingLocation()
            
            self.getAddressFromLatLong(locationObj)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case CLAuthorizationStatus.Restricted:
            self.locationManager.stopUpdatingLocation()
            self.delegate?.getLocationAuthorizationMessage("Restricted Access to location")
            
        case CLAuthorizationStatus.Denied:
            self.locationManager.stopUpdatingLocation()
            self.delegate?.getLocationAuthorizationMessage("Denied Access to location")
            
        case CLAuthorizationStatus.NotDetermined:
            self.locationManager.stopUpdatingLocation()
            print("Status not determined")
            
        default:
            print("Allowed to location Access")
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Reverse geocoding method
    func getAddressFromLatLong(location:CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                print("Error:  \(error.localizedDescription)")
            } else {
                let placemark : CLPlacemark = placemarks!.last!
                self.dictAddress = [
                    "streetname":     placemark.thoroughfare!,
                    "city":     placemark.locality!,
                    "state":    placemark.administrativeArea!,
                    "country":  placemark.country!
                ]
                print("Location:  \(self.dictAddress)")
            }
        })
    }
    
}