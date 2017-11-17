//
//  WSCarouselView.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

let MAX_SECTION_NUM = 10000;

public struct CarouselInfo {
    var collectionViewName: String!;
    var itemSize: CGSize!;
    var minimumSpacing: CGFloat!;
    var scrollDirection: UICollectionViewScrollDirection;
    public var scale:CGFloat? = 1;
    public var backgroudColor:UIColor? = UIColor.white;
    public init(collectionViewName:String,
         itemSize:CGSize,
         minimumSpacing:CGFloat,
         scrollDirection:UICollectionViewScrollDirection) {
        self.collectionViewName = collectionViewName;
        self.itemSize = itemSize;
        self.minimumSpacing = minimumSpacing;
        self.scrollDirection = scrollDirection;
    }
}

public final class WSCarouselView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let CELL_IDENTIFIER = "CAROUSEL_CELL_IDENTIFIER"
    static let CELL_MIN_SPACING: CGFloat = 10000

    lazy private var collectionViewFlowLayout: WSCarouselCollectionViewFlowLayout = {
        () -> WSCarouselCollectionViewFlowLayout in
        let flowLayout = WSCarouselCollectionViewFlowLayout.init();
        flowLayout.minimumLineSpacing = self.carouselInfo.minimumSpacing;
        flowLayout.minimumInteritemSpacing = WSCarouselView.CELL_MIN_SPACING;
        flowLayout.scrollDirection = self.carouselInfo.scrollDirection;
        flowLayout.itemSize = self.carouselInfo.itemSize;
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5);
        if let scale = self.carouselInfo.scale {
            flowLayout.scale = scale;
        }
        return flowLayout;
    }();
    lazy private var collectionView: UICollectionView = {
        () -> UICollectionView in
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.collectionViewFlowLayout);
        collectionView.backgroundColor = self.carouselInfo.backgroudColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.decelerationRate = 0;
        collectionView.register(self.swiftClassFromString(className: self.carouselInfo.collectionViewName), forCellWithReuseIdentifier: WSCarouselView.CELL_IDENTIFIER)

        return collectionView;
    }()
    private var carouselInfo: CarouselInfo;
    
    
    public init(frame: CGRect, carouselInfo:CarouselInfo) {
        self.carouselInfo = carouselInfo;
        super.init(frame: frame);
        
        self.addSubview(self.collectionView);
        self.layoutIfNeeded();
        self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: MAX_SECTION_NUM/2), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDelegate
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MAX_SECTION_NUM;
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WSCarouselView.CELL_IDENTIFIER, for: indexPath);
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    // MARK: - ScrollViewDelegate
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToIndex();
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollToIndex();
    }

    // MARK: - private
    func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String? {
            //拼接控制器名
            let classStringName = "\(appName).\(className)"
            //将控制名转换为类
            let classType = NSClassFromString(classStringName) as? UICollectionViewCell.Type
            if let type = classType {
                return type
            }
        }
        return nil;
    }
    
    func scrollToIndex() {
        let point = self.convert(self.collectionView.center, to: self.collectionView);
        let indexPath = self.collectionView.indexPathForItem(at: point);
        
        if let _ = indexPath {
//            let toIndexPath = IndexPath.init(row: ((indexPath?.row)!)%3, section: (indexPath?.section)!)
            self.collectionView.scrollToItem(at: indexPath!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        }
    }
}
