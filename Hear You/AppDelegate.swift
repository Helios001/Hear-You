//
//  AppDelegate.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import RESideMenu
import Ruler

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置主Window
        customWindow()
        
        // 自定义TabBar样式
        customTabBarAppearance()
        
        // 自定义Navigation样式
        customNavigationAppearance()
        
        // 创建本地数据库表
        configureRealmTable()
        
        // 设置后台模式
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            println(error.description)
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - 配置界面风格
    
    private func customWindow() {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = customRootViewController()
        window?.backgroundColor = UIColor.menuBackColor()
        window?.makeKeyAndVisible()
    }
    
    private func customRootViewController() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainVC = storyboard.instantiateViewControllerWithIdentifier("HYTabBarController") as! HYTabBarController
        
        let menuController = MenuViewController()
        
        let deamonController = RESideMenu(contentViewController: mainVC, leftMenuViewController: menuController, rightMenuViewController: nil)
        
        deamonController.menuPreferredStatusBarStyle = .LightContent
        deamonController.delegate = self
        deamonController.scaleMenuView = false
        deamonController.fadeMenuView = false
        deamonController.panGestureEnabled = true
        deamonController.panFromEdge = true
        deamonController.contentViewInPortraitOffsetCenterX = Ruler.iPhoneHorizontal(100, 120, 140).value
        deamonController.contentViewShadowEnabled = false
        deamonController.scaleContentView = false
        
        return deamonController
    }
    
    // 自定义TabBar样式
    private func customTabBarAppearance() {
        
        UITabBar.appearance().translucent = false
        UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0, -2)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.defaultRedColor()], forState: .Selected)
    }
    
    // 自定义Navigation样式
    private func customNavigationAppearance() {
        
        UINavigationBar.appearance().translucent = false
        
        // 自定义Title样式
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.navigationBarTitleFont(),
            NSForegroundColorAttributeName : UIColor.defaultBlackColor()
        ]
        
        // 自定义返回按钮图片
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "main_arrow_left")?.imageWithRenderingMode(.AlwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "main_arrow_left")?.imageWithRenderingMode(.AlwaysOriginal)
        
        // 隐藏返回按钮的文字
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
    }
    
    // MARK: - configureRealmTable
    private func configureRealmTable() {
        
        if let realm = try? Realm() {
            if (getRealmCategoryWithCategoryName(DefaultCategory.CURRENT.description, inRealm: realm) == nil) {
                let category = RealmSongCategory()
                
                category.name = DefaultCategory.CURRENT.description
                
                let _ = try? realm.write {
                    realm.add(category)
                }
            }
            if (getRealmCategoryWithCategoryName(DefaultCategory.SEARCH.description, inRealm: realm) == nil) {
                let category = RealmSongCategory()
                
                category.name = DefaultCategory.SEARCH.description
                
                let _ = try? realm.write {
                    realm.add(category)
                }
            }
            if (getRealmCategoryWithCategoryName(DefaultCategory.DOWNLOADED.description, inRealm: realm) == nil) {
                let category = RealmSongCategory()
                
                category.name = DefaultCategory.DOWNLOADED.description
                
                let _ = try? realm.write {
                    realm.add(category)
                }
            }
            if (getRealmCategoryWithCategoryName(DefaultCategory.LATEST.description, inRealm: realm) == nil) {
                let category = RealmSongCategory()
                
                category.name = DefaultCategory.LATEST.description
                
                let _ = try? realm.write {
                    realm.add(category)
                }
            }
            if (getRealmCategoryWithCategoryName(DefaultCategory.FAVOURITE.description, inRealm: realm) == nil) {
                let category = RealmSongCategory()
                
                category.name = DefaultCategory.FAVOURITE.description
                
                let _ = try? realm.write {
                    realm.add(category)
                }
            }
        }
    }
}

extension AppDelegate: RESideMenuDelegate {
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        println("willShowMenuViewController")
    }
    
}

