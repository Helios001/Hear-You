//
//  BaseViewController.swift
//  BaseKit
//
//  Created by 董亚珣 on 16/4/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class BaseViewController: SegueViewController {

    var animatedOnNavigationBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else {
            return
        }
        
        if navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animatedOnNavigationBar)
        }
    }
}

