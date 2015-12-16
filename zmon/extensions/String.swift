//
//  String.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func setColor(stringPart stringPart: String, color: UIColor) -> NSAttributedString {
        let range = (self as NSString).rangeOfString(stringPart)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)

        return attributedString
    }
}
