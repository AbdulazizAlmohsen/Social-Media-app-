//
//  LeftVC.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/11/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit


open class RightMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView: UITableView = UITableView.init(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 2) / 2.0, width: self.view.frame.size.width, height: 54 * 2), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleBottomMargin , UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        tableView.scrollsToTop = false
        
        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }
    
    // MARK: - <UITableViewDelegate>
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.row) {
            
        case 0:
            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "feed")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            break
        case 1:
            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            break
        default:
            break
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 2
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.font = UIFont.init(name: "HelveticaNeue", size: 21)
            cell!.textLabel?.textColor = UIColor.blue
            cell!.textLabel?.highlightedTextColor = UIColor.lightGray
            cell!.selectedBackgroundView = UIView.init()
        }
        
        var titles:[String] = ["road 1", "Test 2"]
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.textLabel?.textAlignment = NSTextAlignment.right
        
        return cell!
    }
}
