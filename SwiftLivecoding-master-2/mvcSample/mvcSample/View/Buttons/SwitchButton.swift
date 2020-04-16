//
//  SwitchButton.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 10/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

final class SwitchButton: UIButton {
    var firstString: String = "°C" {
        didSet {
            setupSwitching()
        }
    }
    var secondString: String = "°F" {
        didSet {
            setupSwitching()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSwitching()
    }

    private func setupSwitching() {
        var attributedString = NSMutableAttributedString()
        let lightAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light),
                               NSAttributedString.Key.foregroundColor: UIColor.white]
        let mediumAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.medium),
                                NSAttributedString.Key.foregroundColor: UIColor.white]

        attributedString.append(NSAttributedString(string: firstString,
                                                   attributes: mediumAttributes))
        attributedString.append(NSAttributedString(string: " / ",
                                                   attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: secondString,
                                                   attributes: lightAttributes))
        setAttributedTitle(attributedString, for: .normal)

        attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: firstString,
                                                   attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: " / ",
                                                   attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: secondString,
                                                   attributes: mediumAttributes))
        setAttributedTitle(attributedString, for: .selected)
    }
}
