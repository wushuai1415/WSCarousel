//
//  WSCollectionViewCell.swift
//  WSCarousel
//
//  Created by 吴帅 on 2017/11/15.
//

import UIKit

class WSCollectionViewCell: UICollectionViewCell {

    lazy var label:UILabel = {
        () -> UILabel in
        let label = UILabel.init(frame:CGRect.init(x: 50, y: 50, width: 100, height: 50));
        label.textColor = UIColor.white;
        return label;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.contentView.backgroundColor = UIColor.red;
        self.contentView.layer.borderWidth = 3;
        self.addSubview(label);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
