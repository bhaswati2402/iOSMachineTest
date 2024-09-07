//
//  ShadowView.swift
//  iOSMachineTest
//
//  Created by Bhaswati Sadhukhan on 07/09/24.
//

import Foundation
import UIKit
/// create a shadow view
class ShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    private func setupShadow() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
}
