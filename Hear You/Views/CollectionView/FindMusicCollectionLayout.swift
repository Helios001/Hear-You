//
//  FindMusicCollectionLayout.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

let _naviHeight : CGFloat = 0

class FindMusicCollectionLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
//    var keepAttributes : UICollectionViewLayoutAttributes!
    

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 获取父类返回的所有item的layout信息
        
        var superArray = NSArray(array: super.layoutAttributesForElementsInRect(rect)!, copyItems: true) as! [UICollectionViewLayoutAttributes]
        
        let noneHeaderSections = NSMutableIndexSet()
        
        // 遍历superArray,得到当前屏幕中所有section
        for attributes in superArray {
            if attributes.representedElementCategory == .Cell {
                noneHeaderSections.addIndex(attributes.indexPath.section)
            }
        }
        
        // 遍历superArray,将当前屏幕中拥有header的section从数组中移除
        for attributes in superArray {
            if attributes.representedElementKind == UICollectionElementKindSectionHeader {
                noneHeaderSections.removeIndex(attributes.indexPath.section)
            }
        }
        
        //
        noneHeaderSections.enumerateIndexesUsingBlock { (idx, boolP) in
            // 取到当前section中第一个item的indexPath
            let indexPath = NSIndexPath.init(forItem: 0, inSection: 2)
            // 获取当前section在正常情况下已经离开屏幕的header的信息
            let attributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            
            if let attributes = attributes {
                superArray.append(attributes)
            }
        }
        
//        let indexPath = NSIndexPath.init(forItem: 0, inSection: 2)
//        // 获取当前section在正常情况下已经离开屏幕的header的信息
//        let attributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
//        
//        if let attributes = attributes {
//            superArray.append(attributes)
//        }
        
        // 遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
        for attributes in superArray {
            
            if attributes.representedElementKind == UICollectionElementKindSectionHeader && attributes.indexPath.section == 2 {
                // 得到当前header所在分区的cell的数量
                let numberOfItemsInSection = self.collectionView!.numberOfItemsInSection(attributes.indexPath.section)
                // 得到第一个item的indexPath
                let firstItemIndexPath = NSIndexPath.init(forItem: 0, inSection: attributes.indexPath.section)
                
                var firstItemAttributes : UICollectionViewLayoutAttributes!
                
                if numberOfItemsInSection > 0 {
                    firstItemAttributes = self.layoutAttributesForItemAtIndexPath(firstItemIndexPath)
                } else {
                    firstItemAttributes = UICollectionViewLayoutAttributes()
                    let y = CGRectGetMaxY(attributes.frame) + self.sectionInset.top
                    firstItemAttributes.frame = CGRectMake(0, y, 0, 0)
                }
                
                var rect = attributes.frame
                
                let offset = self.collectionView!.contentOffset.y + _naviHeight
                
                let headerY = firstItemAttributes.frame.origin.y - rect.height - self.sectionInset.top

                let maxY = max(offset, headerY)
                
                rect.y = maxY
                
                attributes.frame = rect
                
                attributes.zIndex = 20
            }
            
            if attributes.representedElementCategory == .Cell {
                
                var rect = attributes.frame
                
                switch attributes.indexPath.section {
                case 3:
                    if attributes.indexPath.row == 1 || attributes.indexPath.row == 2 {
                        rect.x += 10
                    }
                case 4:
                    if attributes.indexPath.row == 0 {
                        rect.x += 10
                    } else if attributes.indexPath.row == 2 {
                        rect.x -= 10
                    }
                case 5:
                    switch attributes.indexPath.row {
                    case 0,2:
                        rect.x += 10
                    case 1,3:
                        rect.x -= 10
                    default:
                        break
                    }
                default:
                    break
                }
                
                attributes.frame = rect
            }
        }
        
        return superArray
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}


