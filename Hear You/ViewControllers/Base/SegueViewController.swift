//
//  SegueViewController.swift
//  BaseKit
//
//  Created by 董亚珣 on 16/4/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {

    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        if let navigationController = navigationController {
            guard navigationController.topViewController == self else {
                return
            }
        }
        
        super.performSegueWithIdentifier(identifier, sender: sender)
    }
    
}
