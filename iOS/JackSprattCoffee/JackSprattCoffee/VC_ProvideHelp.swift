//
//  VC_NeedHelp.swift
//  JackSprattCoffee
//
//  Created by Theo Chino on 12/22/16.
//  CopyLeft © 2016 TheoChino. None of the rights are reserved.
//
//  This is based on the code taken in Lynda.com Classes by Todd Perkins
//  DetectBeaconViewController.swift - BeaconDemo

import UIKit
import CoreBluetooth
import CoreLocation

class DetectBeaconViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var uuidLabel:UILabel!
    @IBOutlet weak var majorLabel:UILabel!
    @IBOutlet weak var minorLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var rangingButton:UIButton!
    
    var beaconRegion:CLBeaconRegion!
    var locationManager:CLLocationManager!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Main
    
    func initializeLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Need to figure out the UUID for beacon receive ..... to make sure it is found.
        let uuid = UUID(uuidString: "3F643DCB-DD1E-4300-8FD6-91543CD0E648")! as UUID
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "com.agi.beacon")
        
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
    }
    
    func toggleRanging() {
        if !isSearching {
            self.initializeLocationManager()
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
            isSearching = true
        } else {
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            locationManager.stopUpdatingLocation()
            isSearching = false
        }
    }
    
    func updateStatusLabels(beacons:[CLBeacon]){
        let beacon = beacons[0] as CLBeacon
        uuidLabel.text = beacon.proximityUUID.uuidString
        majorLabel.text = "Major: \(beacon.major.stringValue)"
        minorLabel.text = "Minor: \(beacon.minor.stringValue)"
        
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        statusLabel.text = "Beacon found is \(self.getProximityString(proximity: beacon.proximity)), it is \(accuracy)m away"
        
        uuidLabel.isHidden = false
        majorLabel.isHidden = false
        minorLabel.isHidden = false
    }
    
    func updateButtonTitle() {
        if isSearching {
            self.rangingButton.setTitle("Stop Ranging", for: .normal)
        } else {
            self.rangingButton.setTitle("Start Ranging", for: .normal)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        //
        if state == .inside {
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //
        print("beacon entered: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //
        print("beacon exited: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            self.updateStatusLabels(beacons: beacons)
            
            locationManager.stopRangingBeacons(in: region)
            
            self.updateButtonTitle()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("failed: \(error)")
    }
    
    // MARK: Actions
    @IBAction func startButtonPressed(sender:Any){
        self.toggleRanging()
        self.updateButtonTitle()
    }
    
    @IBAction func closeWindow() {
        if let presenter = self.presentingViewController{
            if isSearching {
                locationManager.stopMonitoring(for: beaconRegion)
                locationManager.stopUpdatingLocation()
            }
            
            presenter.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Helper
    func getProximityString(proximity:CLProximity) -> String {
        switch proximity {
        case .near:
            return "Near"
            
        case .immediate:
            return "Immediate"
            
        case .far:
            return "Far"
            
        case .unknown:
            return "Unknown"
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
