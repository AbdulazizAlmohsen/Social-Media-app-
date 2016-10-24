//
//  FirstVC.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/11/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit

class FirstViewController : UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("FirstViewController will appear")
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("FirstViewController will disappear")
    }
    
    
   
    
    @IBAction func present(_ sender: UIButton!) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func presenttwo(_ sender: UIButton!) {
        self.sideMenuViewController!.presentRightMenuViewController()
    }

}
    


        
    
    
    

