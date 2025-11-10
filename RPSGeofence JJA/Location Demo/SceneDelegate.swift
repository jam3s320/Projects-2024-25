//
//  SceneDelegate.swift
//  Location Demo
//
//  Created by Ameen Mustafa on 11/11/23.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI

class LocationListener: ObservableObject {
    @Published var isInZone = false
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isInZone = LocationListener()
    let locationManager = CLLocationManager()
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = Main()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView:  contentView.environmentObject(isInZone))
            self.window = window
            window.makeKeyAndVisible()
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // Make sure to add necessary info.plist entries
        
        let locationCoordinates = CLLocationCoordinate2D(latitude: 40.52611754760156, longitude: -74.49504536044343) // RPS
        
        //40.52466314491011, -74.4943495349472 test coords
        startMonitorRegionAtLocation(center: locationCoordinates, identifier: "RPS")
    }
    //40.52599370689592, -74.49516811523976
    
    func startMonitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
           
            let maxDistance = 110.0;
            
            // Register the region.
            let region = CLCircularRegion(center: center,
                 radius: maxDistance, identifier: identifier)
 
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            locationManager.startMonitoring(for: region)
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            //isInZone.isInZone = region.contains(locationManager.location!.coordinate) ? true : false
            
            if let currentLocation = locationManager.location {
                isInZone.isInZone = region.contains(currentLocation.coordinate) ? true : false
            } else {
                // Handle the case where location is nil (e.g., location services not available)
                isInZone.isInZone = false
            }
        }
    }
}

extension SceneDelegate : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //print(locationManager.location)
        isInZone.isInZone = true
        print(isInZone.isInZone)
        if UIApplication.shared.applicationState == .active {
            print("behold RPS in all its eternal majesty")
            
        } else {
            
          let body = "You arrived at " + region.identifier
          let notificationContent = UNMutableNotificationContent()
          notificationContent.body = body
          notificationContent.sound = .default
          notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
          UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              print("Error: \(error)")
            }
          }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        isInZone.isInZone = false
        print(isInZone.isInZone)
        if UIApplication.shared.applicationState == .active {
            print("you have left RPS")
        } else {
            
            let body = "You left " + region.identifier
          let notificationContent = UNMutableNotificationContent()
          notificationContent.body = body
          notificationContent.sound = .default
          notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
          UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              print("Error: \(error)")
            }
          }
        }
    }
}



//Task: Display on widget. Display Sports. Make notifications small and instant (Boys Bball W 77-65), make sure it is able to fit inside the widget. Since calendar only gives basketball sports use the name for all sports but only use scores from basketball for now.
//Subscribe to rps calendar, pull only public information, read that.
//Find evenets on calendar, look for score/name of event.
//Change widget display after 4 seconds.


//webcal://rutgersprep.myschoolapp.com/podium/feed/iCal.aspx?z=VijRkTpf%2b%2bkiKeM9CbRW%2fJUUmuy88dvZGrBNiTUX%2b8BLvc72abRPcGkPofpaddd8E1%2fM6WoPmbPv3hUFhkjEkA%3d%3d
