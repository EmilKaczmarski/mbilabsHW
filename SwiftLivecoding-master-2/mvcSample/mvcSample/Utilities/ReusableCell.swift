//
//  ReusableCell.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 07/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var id: String { get }
}

extension ReusableCell where Self: UITableViewCell {
    static var id: String {
        return String(describing: type(of: Self.self)).replacingOccurrences(of: ".Type", with: "")
    }
}

extension UITableViewCell: ReusableCell {}

extension ReusableCell where Self: UICollectionViewCell {
    static var id: String {
        return String(describing: type(of: Self.self)).replacingOccurrences(of: ".Type", with: "")
    }
}

extension UICollectionViewCell: ReusableCell {}
