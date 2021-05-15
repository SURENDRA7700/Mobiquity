//
//  UIViewExtensions.swift
//  eGroceryy
//
//  Created by Ajeet N on 01/08/19.
//  Copyright © 2019 Ajeet N. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable var shadowColor: UIColor? = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0) {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
}






