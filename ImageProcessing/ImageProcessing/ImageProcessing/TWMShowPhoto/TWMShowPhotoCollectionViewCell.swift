//
//  TWMShowPhotoCollectionViewCell.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//

import Foundation
import UIKit

class TWMShowPhotoCollectionViewCell: UICollectionViewCell {
     
    var titleLabel:UILabel? //title
    // 用来展示图片
    var imageView: UIImageView = {
        let view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: (kScreenW)/3, height: (kScreenW)/3))
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "test_jpg")
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: (kScreenW-40)/2, height: 50))

        self.addSubview(imageView)
    }
}

