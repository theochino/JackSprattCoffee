//
//  VC_NeedHelp.swift
//  JackSprattCoffee
//
//  Created by Theo Chino on 12/22/16.
//  CopyLeft © 2016 TheoChino. None of the rights are reserved.
//
//  This is based on the code taken in Lynda.com Classes by Todd Perkins
//  DeviceBeaconViewController.swift - BeaconDemo

import UIKit
import CoreBluetooth
import CoreLocation

class DeviceBeaconViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var beaconRegion:CLBeaconRegion!
    var peripheralManager:CBPeripheralManager!
    var isBroadcasting = false
    var dataDictionary = NSDictionary()
    
    @IBOutlet weak var uuidField:UITextField!
    @IBOutlet weak var majorField:UITextField!
    @IBOutlet weak var minorField:UITextField!
    @IBOutlet weak var bluetoothStatusLabel:UILabel!
    @IBOutlet weak var beaconStatusLabel:UILabel!
    @IBOutlet weak var beaconButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DeviceBeaconViewController.dismissKeyboard)))
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)

        // The UUID Field need to become random.
        uuidField.text = "3F643DCB-DD1E-4300-8FD6-91543CD0E648"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Main
    func checkBroadcastState(){
        if !isBroadcasting {
            switch peripheralManager.state {
            case .poweredOn:
                self.startAdvertising()
                self.updateBeaconStatus()
                self.updateButtonTitle()
                break
            case .poweredOff:
                break
            case .resetting:
                break
            case .unauthorized:
                break
            case .unknown:
                break
            case .unsupported:
                break
            }
        } else {
            peripheralManager.stopAdvertising()
            isBroadcasting = false
            self.updateBeaconStatus()
            self.updateButtonTitle()
        }
    }
    
    func startAdvertising() {
        beaconRegion = self.createBeaconRegion()
        dataDictionary = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising((dataDictionary as! [String : Any]))
        isBroadcasting = true
    }
    
    func createBeaconRegion() -> CLBeaconRegion? {
        if let uuidString = uuidField.text {
            let uuid = UUID(uuidString: uuidString)!
            let major = Int(majorField.text!)!
            let minor = Int(minorField.text!)!
            
            return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "com.agi.beacon")
        }
        
        return nil
    }
    
    // MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        //
        switch peripheral.state {
        case .poweredOn:
            bluetoothStatusLabel.text = "Bluetooth powered on"
            break

        case .poweredOff:
            bluetoothStatusLabel.text = "Bluetooth powered off"
            break
        
        case .resetting:
            bluetoothStatusLabel.text = "Bluetooth resetting"
            break
        
        case .unauthorized:
            bluetoothStatusLabel.text = "Use of bluetooth unauthorized"
            break
        
        case .unsupported:
            bluetoothStatusLabel.text = "Bluetooth is unsupported"
            break
        
        case .unknown:
            bluetoothStatusLabel.text = "Bluetooth status unknown"
            break
        }
    }
    
    // MARK: Helper
    func updateButtonTitle() {
        if isBroadcasting {
            self.beaconButton.setTitle("Stop Broadcasting", for: .normal)
        } else {
            self.beaconButton.setTitle("Start Broadcasting", for: .normal)
        }
    }
    
    func updateBeaconStatus(){
        if isBroadcasting {
            beaconStatusLabel.text = "Beacon Status: Broadcasting"
        } else {
            beaconStatusLabel.text = "Beacon sStatus: Not broadcasting"
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func startButtonPressed(sender:Any){
        if uuidField.text == "" || majorField.text == "" || minorField.text == "" {
            self.showAlert(title: "Error", message: "Please complete all fields")
            return
        } else {
            self.checkBroadcastState()
        }
        
    }
    
    @IBAction func closeWindow() {
        if let presenter = self.presentingViewController{
            presenter.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
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


