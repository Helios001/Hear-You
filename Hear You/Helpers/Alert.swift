//
//  Alert.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/18.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol PopViewDelegate {
    
    func popView(popView:Pop, didSelectItemAtIndex index: Int)
}

class Pop : UIWindow {
    
    let cellIdentifier = "PopCell"
    
    private var itemView : UITableView?
    private var itemList = [String]()
    var delegate : PopViewDelegate?
    
    init(choices: [String]) {
        super.init(frame: screenBounds)
        
        itemList = choices
        
        let itemViewHeight = CGFloat(44 * choices.count)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.windowLevel = UIWindowLevelNormal
        
        itemView = UITableView(frame: CGRect(x: 0, y: screenBounds.height, width: screenBounds.width, height: itemViewHeight))
        
        if let itemView = itemView {
            
            itemView.backgroundColor = UIColor.whiteColor()
            itemView.scrollEnabled = false
            itemView.delegate = self
            itemView.dataSource = self
            itemView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            
            self.addSubview(itemView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func popFromBottomInViewController() {
        
        self.makeKeyAndVisible()
        
        if let itemView = itemView{
            
            var frame = itemView.frame
            frame.y = screenBounds.height - frame.height
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                itemView.frame = frame
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    }
            })
        }
    }
    
    @objc func dismiss() {
        
        for gesture in self.gestureRecognizers! {
            self.removeGestureRecognizer(gesture)
        }
        
        if let itemView = itemView {
            
            var frame = itemView.frame
            frame.y = screenBounds.height
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                itemView.frame = frame
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                
                }, completion: { (finished) -> Void in
                    if finished {
                        itemView.removeFromSuperview()
                        self.alpha = 0
                        self.resignKeyWindow()
                    }
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismiss()
    }
}

extension Pop : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = itemList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        guard let delegate = delegate else {
            return
        }
        
        delegate.popView(self, didSelectItemAtIndex: indexPath.row)
    }
}

class Alert: NSObject {
    
    class func showMiddleHint(hint: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let view = appDelegate.window
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        hud.userInteractionEnabled = false
        hud.mode = .Text
        hud.labelText = hint
        hud.labelFont = UIFont.systemFontOfSize(15)
        hud.margin = 10
        hud.yOffset = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2.0)
    }
}



