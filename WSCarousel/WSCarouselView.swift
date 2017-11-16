//
//  WSCarouselView.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

public struct CarouselInfo {
    var collectionViewName: String!;
    var itemSize: CGSize?;
    var minimumSpacing: CGFloat!;
    var scrollDirection: UICollectionViewScrollDirection;
    public var scale:CGFloat? = 1;
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

    private var collectionViewFlowLayout: WSCarouselCollectionViewFlowLayout {
        get {
            let flowLayout = WSCarouselCollectionViewFlowLayout.init();
            flowLayout.minimumLineSpacing = self.carouselInfo.minimumSpacing;
            flowLayout.minimumInteritemSpacing = WSCarouselView.CELL_MIN_SPACING;
            flowLayout.scrollDirection = self.carouselInfo.scrollDirection;
            if let scale = self.carouselInfo.scale {
                flowLayout.scale = scale;
            }
            if let itemSize = self.carouselInfo.itemSize {
                flowLayout.itemSize = itemSize;
            } else {
                flowLayout.itemSize = self.bounds.size;
            }

            return flowLayout;
        }
    }
    private var collectionView: UICollectionView {
        get {
            let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.collectionViewFlowLayout);
            collectionView.backgroundColor = UIColor.white;
            collectionView.delegate = self;
            collectionView.dataSource = self;
//            collectionView.isPagingEnabled = true;
            collectionView.register(swiftClassFromString(className: self.carouselInfo.collectionViewName), forCellWithReuseIdentifier: WSCarouselView.CELL_IDENTIFIER)

            return collectionView;
        }
        set {
            
        }
    }
    private var carouselInfo: CarouselInfo;
    
    
    init(frame: CGRect, carouselInfo:CarouselInfo) {
        self.carouselInfo = carouselInfo;
        super.init(frame: frame);
        
        self.addSubview(self.collectionView);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WSCarouselView.CELL_IDENTIFIER, for: indexPath);
        return cell;
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
    
}
