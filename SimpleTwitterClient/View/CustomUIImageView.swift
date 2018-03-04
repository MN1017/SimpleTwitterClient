//
//  CustomUIImageView.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/1/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIImageView: UIImageView {

    var cornerRadiusDependentOnScreenEnable: Bool = false
    
    //
    //  Corner Radius
    //
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            let bounds = UIScreen.main.bounds
            let height = bounds.size.height
            if cornerRadiusDependentOnScreenEnable {
            self.layer.cornerRadius = min( ( height / 200), cornerRadius ) * cornerRadius
            }else{
                self.layer.cornerRadius = cornerRadius 
            }
        }
    }
    
    //
    //  Corner Radius Dependent On Screen Enable
    //
    @IBInspectable var cornerRadiusDependentOnScreen: Bool = false {
        didSet {
            self.cornerRadiusDependentOnScreenEnable = cornerRadiusDependentOnScreen
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
