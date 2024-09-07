//
//  ViewModel.swift
//  iOSMachineTest
//
//  Created by Bhaswati Sadhukhan on 07/09/24.
//

import Foundation
import CoreBluetooth
import Combine

/// ViewModel for managing Bluetooth scanning, connecting, and device management.
class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    private var peripherals = [CBPeripheral]()
    
    @Published var devices: [BluetoothDevice] = []
    @Published var connectedDevice: CBPeripheral?
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    /// Start scanning for Bluetooth devices
    func startScan() {
        devices.removeAll()
        errorMessage = nil
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    /// Stop scanning for Bluetooth devices
    func stopScan() {
        centralManager.stopScan()
    }
    /// Connect to a selected Bluetooth device
    /// - Parameter device: The device to connect to.
    func connect(to device: BluetoothDevice) {
        centralManager.connect(device.peripheral, options: nil)
    }
    /// Disconnect the current connected device
    func disconnect() {
        if let connectedDevice = connectedDevice {
            centralManager.cancelPeripheralConnection(connectedDevice)
            self.connectedDevice = nil
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
        case .poweredOff:
            errorMessage = "Bluetooth is turned off."
        case .unauthorized:
            errorMessage = "Bluetooth permission is not granted."
        case .unsupported:
            errorMessage = "Bluetooth is not supported on this device."
        default:
            errorMessage = "Unknown Bluetooth error occurred."
        }
    }
    /// Handle discovering Bluetooth devices
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "Unknown"
        let device = BluetoothDevice(name: name, peripheral: peripheral, rssi: RSSI)
        
        /// Prevent duplicates
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
            devices.append(device)
        }
    }
    /// Handle successful connection
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        connectedDevice = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown")")
        errorMessage = "Failed to connect to \(peripheral.name ?? "Unknown")."
    }
    
    /// Handle disconnection
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            errorMessage = "Disconnected from \(peripheral.name ?? "Unknown") with error: \(error.localizedDescription)."
        }
        connectedDevice = nil
    }
}
