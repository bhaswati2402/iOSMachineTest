//
//  BluetoothDeviceModel.swift
//  iOSMachineTest
//
//  Created by Bhaswati Sadhukhan on 07/09/24.
//

import Foundation
import CoreBluetooth

/// Represents a Bluetooth device with its name, peripheral, and signal strength (RSSI).
struct BluetoothDevice {
    let name: String
    let peripheral: CBPeripheral
    let rssi: NSNumber
}
