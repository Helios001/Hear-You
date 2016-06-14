//
//  MenuViewController.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/9.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RESideMenu

class MenuViewController: UIViewController {
    
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height))

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor.defaultBlackColor()
        tableView.bounces = false
        
        view.addSubview(tableView)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 8
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.textLabel?.textColor = UIColor.defaultWhiteColor()
        cell.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
        cell.selectedBackgroundView = UIView()
        
        let titles = ["Home","Calendar","Profile","Settings","Log Out","Home","Calendar","Profile","Settings","Log Out"]
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        switch (indexPath.row) {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.sideMenuViewController.setContentViewController(vc, animated: true)
            self.sideMenuViewController.hideMenuViewController()
        case 1:
            println("1")
        default:
            println("false")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 88
        case 1:
            return 44
        default:
            return 0
        }
    }
}
