//
//  ListViewController.swift
//  iOSMachineTest
//
//  Created by Bhaswati Sadhukhan on 07/09/24.
//

import UIKit
import CoreBluetooth
import Combine

//MARK: - ViewController for displaying and interacting with the list of Bluetooth devices.
class ListViewController: UIViewController {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var bluetoothList: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    private let viewModel = BluetoothViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var devices: [BluetoothDevice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

//MARK: -  Binds the view model to update the view based on data changes.
extension ListViewController {
    private func bindViewModel() {
        loader.startAnimating()
        /// Subscribe to devices list changes
        viewModel.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] devices in
                self?.devices = devices
                self?.bluetoothList.reloadData()
                self?.statusLabel.text = devices.isEmpty ? "No devices found" : ""
                self?.loader.stopAnimating()
            }
            .store(in: &cancellables)
        
        /// Subscribe to connection status changes
        viewModel.$connectedDevice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectedDevice in
                guard let self = self else { return }
                if let device = connectedDevice {
                    self.statusLabel.text = "Connected to \(device.name ?? "Unknown")"
                    self.showSuccessAlert("Connected to \(device.name ?? "Unknown")")
                } else {
                    self.statusLabel.text = "Disconnected"
                }
            }
            .store(in: &cancellables)
        /// Subscribe to error messages
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message)
                }
            }
            .store(in: &cancellables)
    }
}
// MARK: - UITableViewDelegate & UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") ?? UITableViewHeaderFooterView(reuseIdentifier: "HeaderView")
        headerView.textLabel?.text = "Nearby Devices"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListViewCell
        cell.deviceData = devices[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDevice = devices[indexPath.row]
        viewModel.connect(to: selectedDevice)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - Set aleart view
extension ListViewController {
    /// Shows an error alert with the provided message.
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    /// Shows an error alert with the provided message.
    private func showSuccessAlert(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        present(alert, animated: true)
    }
    
}
