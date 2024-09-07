//
//  ListViewCell.swift
//  iOSMachineTest
//
//  Created by Bhaswati Sadhukhan on 07/09/24.
//

import Foundation
import UIKit

/// Represents tableview cell design and show data
class ListViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    var deviceData: BluetoothDevice? {
        didSet {
            nameLabel.text = deviceData?.name
            rssiLabel.text = deviceData?.rssi.stringValue
        }
    }
}
