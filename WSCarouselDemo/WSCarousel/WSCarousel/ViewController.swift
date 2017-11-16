//
//  ViewController.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let info = CarouselInfo.init(collectionViewName: "WSCollectionViewCell",
                                     itemSize: CGSize.init(width: 300, height: 500),
                                     minimumSpacing: 10,
                                     scrollDirection: UICollectionViewScrollDirection.horizontal,
                                     scale: nil);
        let carouselView = WSCarouselView.init(frame: CGRect.init(x: 0, y: 50, width: 375, height: 660), carouselInfo: info);
        self.view.addSubview(carouselView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

