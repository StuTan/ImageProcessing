//
//  TWMShowPhotoController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//
 
import UIKit
import Photos
import ZLPhotoBrowser

class TWMShowPhotoController: UIViewController {

    var collectionView: UICollectionView!
    
    var images: [UIImage] = []
    
    var assets: [PHAsset] = []
    
    var hasSelectVideo = false
    
    static let propertyLabel: Set<String> = ["allowSelectImage", "allowSelectVideo", "allowSelectGif", "allowSelectLivePhoto", "allowSelectOriginal", "cropVideoAfterSelectThumbnail", "allowEditVideo", "allowMixSelect", "maxSelectCount", "maxEditVideoTime"]
    
    let originalConfig: [String: Any] = {
        var dic = [String: Any]()
        for label in propertyLabel {
            dic[label] = ZLPhotoConfiguration.default().value(forKey: label)
        }
        return dic
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        for label in TWMShowPhotoController.propertyLabel {
            ZLPhotoConfiguration.default().setValue(originalConfig[label], forKey: label)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let imagePaths = UserDefaults.standard.stringArray(forKey: "ImagePaths")
        if imagePaths != nil {
            let savePhotoMethod = TWMSavePhotoMethod()
            images = savePhotoMethod.getImage(imageNames: imagePaths!)
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        collectionView.register(TWMShowPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "TWMShowPhotoCollectionViewCell")
    }
    
    func selectPhotos() {
        let config = ZLPhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = images.count == 0
        config.allowSelectGif = false
        config.allowSelectLivePhoto = false
        config.allowSelectOriginal = false
        config.cropVideoAfterSelectThumbnail = true
        config.imageStickerContainerView = TWMImageStickerContainerView()
        config.allowEditVideo = true
        config.allowMixSelect = false
        config.maxSelectCount = 100
        config.maxEditVideoTime = 15
        
        // You can provide the selected assets so as not to repeat selection.
        // Like this 'let photoPicker = ZLPhotoPreviewSheet(selectedAssets: assets)'
        let photoPicker = ZLPhotoPreviewSheet()
        
        photoPicker.selectImageBlock = { [weak self] (images, assets, _) in
            self?.hasSelectVideo = assets.first?.mediaType == .video
            self?.images.append(contentsOf: images) //每次添加选取的图片
            self?.assets.append(contentsOf: assets)
            self?.collectionView.reloadData()
            // 使用其他线程完成图片存储任务
            self?.savePhotos()
        }
        photoPicker.showPhotoLibrary(sender: self)
    }
    
    func savePhotos() {
        var imagePaths = [String]()
        let savePhotoMethod = TWMSavePhotoMethod()
        for image in self.images {
            imagePaths.append(savePhotoMethod.saveImage(image: image))
        }
        UserDefaults.standard.set(imagePaths, forKey: "ImagePaths") //imagePaths
        UserDefaults.standard.synchronize();
    }
    
}


extension TWMShowPhotoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasSelectVideo ? 1 : (images.count + 1)
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            print("开始添加图像")
            selectPhotos()
            print("图像添加完成")
        } else {
            // 点击进入编辑页面
        }
    }
    
}




