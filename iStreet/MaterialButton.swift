//
//  MaterialButton.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/2/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(displayP3Red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        
        layer.shadowOpacity = 10.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        
        


}
}
