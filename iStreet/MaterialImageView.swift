//
//  MaterialImageView.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/12/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import Foundation
import UIKit

override func awakeFromNib() {
    
    layer.cornerRadius = image.frame.size.width / 2
    clipsToBounds = true
    clipsToBounds = true
}
