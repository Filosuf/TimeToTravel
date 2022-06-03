//
//  UICollectionViewCell + Extension.swift
//  TimeToTravel
//
//  Created by 1234 on 01.06.2022.
//

import Foundation
import UIKit

extension UIView {

    func makeLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.layer.cornerRadius = fontSize / 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
