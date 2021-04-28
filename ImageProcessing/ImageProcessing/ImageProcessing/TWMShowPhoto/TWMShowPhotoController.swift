//
//  TWMShowPhotoController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//

import Foundation
import UIKit

private let ImageView_Y: CGFloat = {
    isIphoneX ? 108 : 84
}()

class TWMShowPhotoController: UIViewController {
    
    var showLabel = UILabel()
//    var dataArr = NSMutableArray()//数据源
    var dataArr = ["http://192.168.0.111/111.jpg","http://192.168.0.111/222.jpg"]

    
    lazy var imageView: UIImageView = {
        let view = UIImageView.init(frame: CGRect(x: 20, y: ImageView_Y + kScreenH/2 - 270, width: kScreenW - 40, height: 300))
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "add-btn")
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        view.addGestureRecognizer(singleTapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
     
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0  //水平间隔
        layout.minimumLineSpacing = 5.0       //垂直行间距
        let view = UICollectionView.init(frame: CGRect(x:0, y: ImageView_Y, width: kScreenW, height: kScreenH), collectionViewLayout: layout)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        // 注册cell
        view.register(TWMShowPhotoCollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        view.delegate = self;
        view.dataSource = self;
        // 设置每一个cell的宽高
        layout.itemSize = CGSize(width: (kScreenW-30)/3, height: (kScreenW)/3)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        getData()
        if imageArray.count == 0 {
            self.view.addSubview(imageView)
        } else {
            self.view.addSubview(collectionView)
        }
        
    }
     
    @objc func imageViewClick() {
//        var _: TWMPickerPhotoController = TWMPickerPhotoController()
        print("开始添加图片")
        let vc = TWMPickerPhotoController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("添加图片结束")
    }
    
    
    
//    func getData(){
//        dataArr.append("Tomcat")
//        dataArr.append("Jetty")
//        dataArr.append("Apache")
//        dataArr.append("Jboss")
//    }
}

 
extension TWMShowPhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 返回UICollectionView有多少个组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 返回UICollectionView每个组有多少个元素
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    // 返回UICollectionView的每个Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! TWMShowPhotoCollectionViewCell
        cell.imageView.image = UIImage.init(named: "add-btn")
//        cell.titleLabel?.text = "wangjie"
        return cell
    }
    
    // 点击UICollectionView的Cell执行的操作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击图片，进入图片预览编辑页面")
    }
}
