//
//  UIView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 7.10.22.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

}
