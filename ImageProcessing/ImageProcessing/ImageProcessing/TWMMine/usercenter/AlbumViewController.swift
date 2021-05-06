//
//  AlbumViewController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/5/6.
//

import Foundation
import UIKit

// 第一步: 继承自`UserCenterContentProxyViewController`
class AlbumViewController: UserCenterContentProxyViewController {
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private let reuseIdentifier = "Cell"
    
    var images: [UIImage] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 第二步: 设置contentInset属性
        collectionView.contentInset = defaultScrollContentInsets(for: .navigationBar)
        
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.register(TWMShowPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "TWMShowPhotoCollectionViewCell")
        
        let imagePaths = UserDefaults.standard.stringArray(forKey: "ImagePaths")
        if imagePaths != nil {
            let savePhotoMethod = TWMSavePhotoMethod()
            images = savePhotoMethod.getImage(imageNames: imagePaths!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 第三步: 重写父类方法
    override func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: false)
    }

}


extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.frame.width - 40 - 10) / 3
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TWMShowPhotoCollectionViewCell", for: indexPath) as! TWMShowPhotoCollectionViewCell
        
        if indexPath.row < images.count {
            cell.imageView.image = images[indexPath.row]
//            cell.playImageView.isHidden = assets[indexPath.row].mediaType != .video
        } else {
            cell.imageView.image = UIImage(named: "addPhoto")
            cell.playImageView.isHidden = true
        }
        
        return cell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        let r = CGFloat(arc4random_uniform(256)) / 255.0
//        let g = CGFloat(arc4random_uniform(256)) / 255.0
//        let b = CGFloat(arc4random_uniform(256)) / 255.0
//        cell.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
//        return cell
    }
    
}


extension AlbumViewController: UICollectionViewDelegate {
    
    // 第四步: 如果子类重写了`UIScrollViewDelegate`方法,记得调用父类的方法
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    }
    
}


//extension AlbumViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 10.0) / 3.0
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//}
