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
        
        let inset = ((self.collectionView?.frame.size.width)! - self.itemSize.width) * 0.5;
        // 设置第一个和最后一个默认居中显示
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
        
        var visibleRect:CGRect = CGRect.init();
        visibleRect.origin = (self.collectionView?.contentOffset)!;
        visibleRect.size = (self.collectionView?.frame.size)!;
        
        let collectionViewCenterX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.frame.size.width)! * 0.5;
        
        let attributes = NSArray.init(array: super.layoutAttributesForElements(in: rect)!, copyItems: true);
        for attribute in attributes {
            
            let attrs = attribute as! UICollectionViewLayoutAttributes;
            if(!visibleRect.intersects(attrs.frame)) {
                continue;
            }
            
            var scaleNum : CGFloat;
            // 防止突变的情况(当Item的中心与collectionView中心的距离大于等于collectionView宽度的一半时，Item不缩放，平稳过度)
            if(abs(attrs.center.x - collectionViewCenterX) >= (self.collectionView?.frame.size.width)! * 0.5) {
                scaleNum = scale!;
            } else {
                scaleNum = 1;
            }
            
            attrs.transform3D = CATransform3DMakeScale(scaleNum, scaleNum, 1);
        }
        
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
        var minCenterX = CGFloat.greatestFiniteMagnitude;
        let collectionViewCenterX = proposedContentOffset.x + (self.collectionView?.frame.size.width)! * 0.5;
        for attrs in array! {
            if(abs(attrs.center.x - collectionViewCenterX) < abs(minCenterX)){
                minCenterX = attrs.center.x - collectionViewCenterX;
            }
        }
        
        //3. 补回ContentOffset，则正好将Item居中显示
        return CGPoint.init(x: proposedContentOffset.x + minCenterX, y: proposedContentOffset.y);
    }
}












