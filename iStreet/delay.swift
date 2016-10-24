//
//  delay.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/10/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import Foundation

import Foundation

func delayWithSeconds(_ seconds: Double, completion:   @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
