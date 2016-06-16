//
//  FindMusicCollection.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import SDCycleScrollView
import AlamofireImage

class FindMusicCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posterList = [Album]()
    var newMusicItem : FrontpageElement!
    var hotMusicItem : FrontpageElement!
    var singerItem   : FrontpageElement!
    var recommendItem : FrontpageElement!
    var ownItem      : FrontpageElement!
    
    var pinSection : FrontpagePinView?
    
    
    var posterImageList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbarItem选中图片
        navigationController?.tabBarItem.selectedImage = UIImage(named: "cm2_btm_icn_discovery_prs")!.imageWithRenderingMode(.AlwaysOriginal)
        
        // 导航栏左侧按钮
        let menuBtn = UIButton.init(frame: CGRectMake(0, 0, 30, 40))
        menuBtn.setImage(UIImage(named: "cm2_efc_trlbar_button_prs_line_new"), forState: .Normal)
        menuBtn.addTarget(self, action: Selector("presentLeftMenuViewController:"), forControlEvents: .TouchUpInside)
        let menuItem = UIBarButtonItem.init(customView: menuBtn)
        navigationItem.leftBarButtonItem = menuItem
        
        // 自定义collection布局
        let layout = FindMusicCollectionLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView?.collectionViewLayout = layout
        
        // 注册collectionCell
        collectionView?.registerNib(UINib.init(nibName: "FrontpageTopView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionTop")
        collectionView?.registerNib(UINib.init(nibName: "FrontpagePinView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FrontpagePinView")
        collectionView?.registerNib(UINib.init(nibName: "FrontpageItemView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FrontpageItemView")
        
        
        var allElements = [FrontpageElement]()
        
        // 获取首页展示元素
        getFrontpageInformation(nil) { (elements) in
            
            allElements = elements
            for element in elements {
                
                // MARK: - 设置顶部滚动海报
                if element.id == 2881 {
                    
                    
                    let albums = element.data
                    
                    for album in albums {
                        self.posterList.append(album)
                        self.posterImageList.append(album.picUrl)
                    }
                }
            }
            
            // MARK: - 设置专辑展示列表
            for element in allElements {
                
                if element.id == 2891 {
                    self.newMusicItem = element
                }
                
                if element.id == 2884 {
                    self.hotMusicItem = element
                }
                
                if element.id == 2938 {
                    self.singerItem = element
                }
                
                if element.id == 2937 {
                    self.recommendItem = element
                }
                
                if element.id == 2893 {
                    self.ownItem = element
                }
            }
            
            self.collectionView?.reloadData()
        }
        
    }

    // MARK: UICollectionViewDataSource

    // MARK: - 设置section数目
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 7
    }

    // MARK: - 设置cell数目
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let _ = newMusicItem, _ = hotMusicItem {
            
            switch section {
            case 0,1,2:
                return 0
            case 5:
                return 4
            default:
                return 3
            }
        } else {
            return 0
        }
    }

    
    // MARK: - 设置Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        
        switch indexPath.section {
        case 3:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewMusicCell", forIndexPath: indexPath)
            let album = newMusicItem.data[indexPath.row]
            dispatch_async(dispatch_get_main_queue(), { 
                (cell as! NewMusicCell).element = album
            })
            
        case 4:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotMusicCell", forIndexPath: indexPath)
            let album = singerItem.data[indexPath.row]
            dispatch_async(dispatch_get_main_queue(), {
                (cell as! HotMusicCell).element = album
            })
            
        case 5:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewMusicCell", forIndexPath: indexPath)
            let album = hotMusicItem.data[indexPath.row]
            dispatch_async(dispatch_get_main_queue(), {
                (cell as! NewMusicCell).element = album
            })
            
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotMusicCell", forIndexPath: indexPath)
            let album = ownItem.data[indexPath.row]
            dispatch_async(dispatch_get_main_queue(), {
                (cell as! HotMusicCell).titleLabel.text = album.desc
                if let picURL = NSURL(string: album.picUrl) {
                    let filter = AspectScaledToFillSizeFilter(size: (cell as! HotMusicCell).pic.frame.size)
                    (cell as! HotMusicCell).pic.af_setImageWithURL(picURL, filter: filter)
                }
            })
        }
        
        // 为cell设置圆角和阴影
        cell.layer.cornerRadius = 5
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.darkGrayColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath.init(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).CGPath
        
        return cell
    }
    
    // MARK: - 设置sectionHeader
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if let newMusicItem = newMusicItem, let hotMusicItem = hotMusicItem, let singerItem = singerItem, let ownItem = ownItem {
            switch indexPath.section {
            case 0:
                let topView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionTop", forIndexPath: indexPath) as! FrontpageTopView
                
                topView.mainScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
                topView.mainScroll.autoScrollTimeInterval = 5.0
                topView.mainScroll.currentPageDotColor = UIColor.whiteColor()
                topView.mainScroll.imageURLStringsGroup = posterImageList
                
                return topView
                
            case 1:
                let itemView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "FrontpageItemView", forIndexPath: indexPath) as! FrontpageItemView
                return itemView
                
            case 2:
                let pinView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "FrontpagePinView", forIndexPath: indexPath) as! FrontpagePinView
                pinSection = pinView
                pinView.index = 1
                return pinView
                
            case 3:
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionHeader", forIndexPath: indexPath) as! FrontpageSectionHeader
                view.titleButton.setTitle(newMusicItem.name, forState: .Normal)
                return view
                
            case 4:
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionHeader", forIndexPath: indexPath) as! FrontpageSectionHeader
                view.titleButton.setTitle(singerItem.name, forState: .Normal)
                return view
                
            case 5:
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionHeader", forIndexPath: indexPath) as! FrontpageSectionHeader
                view.titleButton.setTitle(hotMusicItem.name, forState: .Normal)
                return view
                
            default:
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionHeader", forIndexPath: indexPath) as! FrontpageSectionHeader
                view.titleButton.setTitle(ownItem.name, forState: .Normal)
                return view
            }
        } else {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MusicCollectionHeader", forIndexPath: indexPath) as! FrontpageSectionHeader
            return view
        }
        
        
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    // MARK: - 设置每个cell的size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0,1,2:
            return CGSizeZero
        case 3:
            switch indexPath.row {
            case 0:
                return CGSizeMake((screenBounds.width - 20) , (screenBounds.width - 20) * 3 / 4)
            default:
                return CGSizeMake((screenBounds.width - 30) / 2, (screenBounds.width - 20) / 2)
            }
        case 4:
            return CGSizeMake((screenBounds.width - 40) / 3, (screenBounds.width - 40) / 3)
        case 5:
            return CGSizeMake((screenBounds.width - 30) / 2, (screenBounds.width - 20) / 2)
        default:
            return CGSizeMake(screenBounds.width - 20, (screenBounds.width - 20) / 2)
        }
    }
    
    // MARK: - 设置每个Header的size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSizeMake(screenBounds.width, screenBounds.width / 2)
        case 1:
            return CGSizeMake(screenBounds.width, 120)
        case 2:
            return CGSizeMake(screenBounds.width, 30)
        default:
            return CGSizeMake(screenBounds.width, 100)
        }
    }
    
    // 
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        pinSection?.index = indexPath.section - 2
    }
}
