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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        collectionView.register(TWMShowPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "TWMShowPhotoCollectionViewCell")
    }
    
    //MARK: - ????????????
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {

        let point = tap.location(in: collectionView)
        let alertController = UIAlertController(title: "?????????????????????", message: "???????????????????????????",
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "??????", style: .destructive, handler: { action in
            self.deletePhotoToAlbum(point: point)
        })
        let archiveAction = UIAlertAction(title: "??????", style: .default, handler:  { action in
            self.savePhotoToAlbum(point: point)
        })
        let sharreAction = UIAlertAction(title: "??????", style: .default, handler:  { action in
            self.sharePhoto(point: point)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addAction(sharreAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func sharePhoto(point: CGPoint) {
        var indexPath: IndexPath?
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {
            return
        }
        let item = collectionView.cellForItem(at: indexPath!) as? TWMShowPhotoCollectionViewCell
        
        // ????????????
        let image: UIImage = (item?.imageView.image)!
        let msg:OSMessage = OSMessage.init()
        msg.title = "Hello World"
//        let image: UIImage = UIImage.init(named: "image1")!
        let imageData = image.compressImage(image: image, maxLength: 32*1024)
        let imageChange = UIImage.init(data: imageData! as Data)
        msg.image = imageChange
        msg.thumbnail = imageChange
        
        let alertController = UIAlertController(title: "????????????", message: "?????????????????????",
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        let weixinSessionAction = UIAlertAction(title: "????????????????????", style: .default, handler: { action in
            OpenShare.share(toWeixinSession: msg, success: {_ in
                UIAlertController.showAlert(message: "???????????????????????????")
            }, fail: {_,_  in
                UIAlertController.showAlert(message: "???????????????????????????")
            })
        })
        
        let weixinTimelineAction = UIAlertAction(title: "???????????????", style: .default, handler: { action in
            OpenShare.share(toWeixinTimeline: msg, success: {_ in
                UIAlertController.showAlert(message: "??????????????????????????????")
            }, fail: {_,_  in
                UIAlertController.showAlert(message: "??????????????????????????????")
            })
        })
        
        
        let weixinFavoriteAction = UIAlertAction(title: "????????????", style: .default, handler: { action in
            OpenShare.share(toWeixinFavorite: msg, success: {_ in
                UIAlertController.showAlert(message: "??????????????????")
            }, fail: {_,_  in
                UIAlertController.showAlert(message: "??????????????????")
            })
        })
        
        let qqFriendsAction = UIAlertAction(title: "QQ??????", style: .default, handler:  { action in
            msg.desc = "??????????????????"
            OpenShare.share(toQQFriends: msg, success: {_ in
                UIAlertController.showAlert(message: "?????????QQ????????????")
            }, fail: {_,_  in
                UIAlertController.showAlert(message: "?????????QQ????????????")
            })
        })
        
        let qqZoneAction = UIAlertAction(title: "??????", style: .default, handler:  { action in
            OpenShare.share(toWeibo: msg, success: {_ in
                UIAlertController.showAlert(message: "?????????????????????")
            }, fail: {_,_  in
                UIAlertController.showAlert(message: "?????????????????????")
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(weixinSessionAction)
        alertController.addAction(weixinTimelineAction)
        alertController.addAction(weixinFavoriteAction)
        alertController.addAction(qqFriendsAction)
        alertController.addAction(qqZoneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
     
        
    func savePhotoToAlbum(point: CGPoint) {
        var indexPath: IndexPath?
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {
            return
        }
        let item = collectionView.cellForItem(at: indexPath!) as? TWMShowPhotoCollectionViewCell
        
        // ???????????????
        let hud = ZLProgressHUD(style: ZLPhotoConfiguration.default().hudStyle)
        let image = item?.imageView.image
        hud.show()
        ZLPhotoManager.saveImageToAlbum(image: image!) { [weak self] (suc, asset) in
            if suc, let at = asset {
                debugPrint("???????????????????????????")
                UIAlertController.showAlert(message: "????????????!")
            } else {
                debugPrint("???????????????????????????")
            }
            hud.hide()
        }
    }
    
    func deletePhotoToAlbum(point: CGPoint) {
        var indexPath: IndexPath?
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {
            return
        }
        let item = collectionView.cellForItem(at: indexPath!) as? TWMShowPhotoCollectionViewCell
        
        // ????????????
        self.images.remove(at: indexPath!.item)
        collectionView.moveItem(at: indexPath!, to: NSIndexPath(item: self.images.count, section: 0) as IndexPath)
        savePhotos()
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
            self?.images.append(contentsOf: images) //???????????????????????????
            self?.assets.append(contentsOf: assets)
            self?.collectionView.reloadData()
            // ??????????????????????????????????????????
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
        } else {
            cell.imageView.image = UIImage(named: "addPhoto")
            cell.playImageView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            print("??????????????????")
            selectPhotos()
            print("??????????????????")
        } else {
            // ????????????????????????
            let image = self.images[indexPath.row] 
            ZLEditImageViewController.showEditImageVC(parentVC: self, image: image) { [weak self] (ei, _) in
                self?.images[indexPath.row] = ei
                self?.collectionView .reloadData()
                self?.savePhotos()
            }
            
        }
    }
    
}




