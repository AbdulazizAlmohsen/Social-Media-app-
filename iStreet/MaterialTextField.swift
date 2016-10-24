//
//  MaterialTextField.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/2/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(displayP3Red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
    }
    

}
