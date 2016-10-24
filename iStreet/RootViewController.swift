//
//  SlideMenueVC.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/11/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit
import AKSideMenu

open class RootViewControllerclass : AKSideMenu, AKSideMenuDelegate {
    
    override open func awakeFromNib() {
        
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        self.contentViewShadowColor = UIColor.black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController")
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "leftMenuViewController")
        self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "rightMenuViewController")
        self.backgroundImage = UIImage(named: "road")
        self.delegate = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - <AKSideMenuDelegate>
    
     open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }
    
     open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}

