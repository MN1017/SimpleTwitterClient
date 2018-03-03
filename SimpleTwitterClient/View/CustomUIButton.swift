//
//  CustomUIButton.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 2/28/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIButton: UIButton {
    
    //
    //  Corner Radius
    //
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.height
            let height = bounds.size.height
            self.layer.cornerRadius = min( cornerRadius * ( height / 200), cornerRadius * ( width / 200) )
        }
    }
    
    //
    //  Border Width
    //
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    //
    //  Border Color
    //
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
