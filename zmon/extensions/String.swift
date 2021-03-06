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
    
    func base64() -> String {
        // UTF 8 str from original
        let utf8str: NSData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        
        // Base64 encode UTF 8 string
        // rawValue:0 is equivalent to objc 'base64EncodedStringWithOptions:0'
        let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Encoded
    }
}
