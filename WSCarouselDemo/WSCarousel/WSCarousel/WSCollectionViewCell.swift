//
//  WSCollectionViewCell.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

class WSCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.contentView.backgroundColor = UIColor.red;
        self.contentView.layer.borderWidth = 3;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
