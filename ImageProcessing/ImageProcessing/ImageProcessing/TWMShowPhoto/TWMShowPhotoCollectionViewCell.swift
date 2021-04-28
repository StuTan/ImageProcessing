//
//  TWMShowPhotoCollectionViewCell.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//

import Foundation
import UIKit

class TWMShowPhotoCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    var playImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        playImageView = UIImageView(image: UIImage(named: "playVideo"))
        playImageView.contentMode = .scaleAspectFit
        playImageView.isHidden = true
        contentView.addSubview(playImageView)
        playImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
