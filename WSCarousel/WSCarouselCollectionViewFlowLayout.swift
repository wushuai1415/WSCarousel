//
//  WSCarouselCollectionViewFlowLayout.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

class WSCarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var scale : CGFloat? = 1.0;
    
    override func prepare() {
        super.prepare();
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // 设置第一个和最后一个默认居中显示
        if self.scrollDirection == UICollectionViewScrollDirection.horizontal {
            let inset = ((self.collectionView?.frame.size.width)! - self.itemSize.width) * 0.5;
            self.collectionView?.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
        } else {
            let inset = ((self.collectionView?.frame.size.height)! - self.itemSize.height) * 0.5;
            self.collectionView?.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
        }
        
        var visibleRect:CGRect = CGRect.init();
        visibleRect.origin = (self.collectionView?.contentOffset)!;
        visibleRect.size = (self.collectionView?.frame.size)!;
        
        let collectionViewCenterX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.frame.size.width)! * 0.5;
        let collectionViewCenterY = (self.collectionView?.contentOffset.y)! + (self.collectionView?.frame.size.height)! * 0.5;
        
        let attributes = NSArray.init(array: super.layoutAttributesForElements(in: rect)!, copyItems: true);
        for attribute in attributes {
            
            let attrs = attribute as! UICollectionViewLayoutAttributes;
            if(!visibleRect.intersects(attrs.frame)) {
                continue;
            }
            
            var scaleNum : CGFloat;
            if self.scrollDirection == UICollectionViewScrollDirection.horizontal {
                // item 偏移视图中心的角力
                let x_offset = abs(attrs.center.x - collectionViewCenterX);
                // 两个item的中心距离
                let centerDistance = (self.itemSize.width+self.minimumLineSpacing) * 0.5;
                // 防止突变的情况(当Item的中心与collectionView中心的距离大于等于collectionView宽度的一半时，Item不缩放，平稳过度)
                if(x_offset >= centerDistance) {
                    scaleNum = 1-((1-scale!)*(x_offset-centerDistance)/centerDistance);
                } else {
                    scaleNum = 1;
                }
            } else {
                // item 偏移视图中心的角力
                let x_offset = abs(attrs.center.y - collectionViewCenterY);
                // 两个item的中心距离
                let centerDistance = (self.itemSize.height+self.minimumLineSpacing) * 0.5;
                // 防止突变的情况(当Item的中心与collectionView中心的距离大于等于collectionView宽度的一半时，Item不缩放，平稳过度)
                if(x_offset >= centerDistance) {
                    scaleNum = 1-((1-scale!)*(x_offset-centerDistance)/centerDistance);
                } else {
                    scaleNum = 1;
                }
            }

            
            attrs.transform3D = CATransform3DMakeScale(scaleNum, scaleNum, 1);
        }
//        let a:UICollectionViewLayoutAttributes = attributes[2] as! UICollectionViewLayoutAttributes;
//        a.zIndex = 1;
        
        return (attributes as! [UICollectionViewLayoutAttributes]);
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        super.shouldInvalidateLayout(forBoundsChange: newBounds);
        return true;
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        //1. 获取UICollectionView停止的时候的可视范围
        var contentFrame = CGRect.init();
        contentFrame.size = (self.collectionView?.frame.size)!;
        contentFrame.origin = proposedContentOffset;
        
        let array = self.layoutAttributesForElements(in: contentFrame);
        
        //2. 计算在可视范围的距离中心线最近的Item
        var minCenter = CGFloat.greatestFiniteMagnitude;
        if self.scrollDirection == UICollectionViewScrollDirection.horizontal {
            let collectionViewCenterX = proposedContentOffset.x + (self.collectionView?.frame.size.width)! * 0.5;
            for attrs in array! {
                if(abs(attrs.center.x - collectionViewCenterX) < abs(minCenter)){
                    minCenter = attrs.center.x - collectionViewCenterX;
                }
            }
            
            //3. 补回ContentOffset，则正好将Item居中显示
            return CGPoint.init(x: proposedContentOffset.x + minCenter, y: proposedContentOffset.y);
        } else {
            let collectionViewCenterY = proposedContentOffset.y + (self.collectionView?.frame.size.height)! * 0.5;
            for attrs in array! {
                if(abs(attrs.center.y - collectionViewCenterY) < abs(minCenter)){
                    minCenter = attrs.center.y - collectionViewCenterY;
                }
            }
            
            //3. 补回ContentOffset，则正好将Item居中显示
            return CGPoint.init(x: proposedContentOffset.x, y: proposedContentOffset.y + minCenter);
        }

    }
}












