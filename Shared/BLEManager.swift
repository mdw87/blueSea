//
//  BLEManager.swift
//  BlueSea
//
//  Created by mike willard on 9/30/21.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {

    var myCentral: CBCentralManager!
    
    var tempSensorPeripheral: CBPeripheral!
    
    @Published var isSwitchedOn = false
    @Published var temp = 0.0
    @Published var humidity = 0.0
    
    override init() {
        super.init()
        
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        } else {
            peripheralName = "Unknown"
        }
        
        print("Found \(String(describing: peripheralName)), rssi: \(String(RSSI.intValue))")
        if (peripheralName == "GVH5102_C203") {
            print("****** Advertisement data Starts here ******")
            print(advertisementData)
            tempSensorPeripheral = peripheral
            decodeAdvertisementData(data: advertisementData)
        }
    }
    
    func decodeAdvertisementData(data: [String : Any]) {
        print("Found govee")
        if let mfg_data = data[CBAdvertisementDataManufacturerDataKey] as? Data {
            let govee_data = [UInt8](mfg_data)
            var hex_data = [String]()
            for n in govee_data {
                hex_data.append(String(format: "%02X", n))
            }
            let packet_hex = hex_data[4...6].joined()
            let packet_int = Int(packet_hex, radix: 16) ?? 0
            print("Packet int: \(packet_int)")
            let humidity = Float(packet_int % 1000) / 10.0
            let temp_c = Float(packet_int) / 10000.0
            let temperature = (temp_c * 9.0/5.0) + 32.0
            self.temp = Double(temperature)
            self.humidity = Double(humidity)
        }
    }
    
    func startScanning() {
        print("Scan started")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        print("Stop scanning")
        myCentral.stopScan()
    }
}
