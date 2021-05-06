//
//  TWMStyleTransferController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/29.
//

import Foundation
import UIKit
import CoreML
import ZLPhotoBrowser
import Photos

class TWMStyleTransferController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    typealias FilteringCompletion = ((UIImage?, Error?) -> ()) 
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
//    var takeSelectedAssetsSwitch: UISwitch!
    var selectedImages: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    
    var selectedNSTModel: NSTDemoModel = .starryNight
    
    var isProcessing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        self.segmentedControl.removeAllSegments()
        for (index, model) in NSTDemoModel.allCases.enumerated() {
            self.segmentedControl.insertSegment(withTitle: model.rawValue, at: index, animated: false)
        }
        self.segmentedControl.selectedSegmentIndex = 0
        
    }

    @IBAction func chooseImage(_ sender: Any) {
        // Choose Image Here
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
        self.showImagePicker(true)
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        let hud = ZLProgressHUD(style: ZLPhotoConfiguration.default().hudStyle)
        let image = self.imageView.image
        hud.show()
        ZLPhotoManager.saveImageToAlbum(image: image!) { [weak self] (suc, asset) in
            if suc, let at = asset {
//                self?.selectedImages = [image]
                self?.selectedAssets = [at]
//                self?.collectionView.reloadData()
                UIAlertController.showAlert(message: "保存成功!")
            } else {
                debugPrint("保存图片到相册失败")
            }
            hud.hide()
        }
    }
    
    @IBAction func transformImage(_ sender: Any) {
        // Style Transfer Here
        let model = StarryStyle()
        
        
//        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
//        styleArray?[0] = 1.0
//
//        if let image = pixelBuffer(from: imageView.image!) {
//            do {
//
////                var error:NSError = NSError()
////                let predictionOutput = try model.prediction(input1: image)
////                imageOutputBufferRef = outPut.output1
//
//
//                let predictionOutput = try model.prediction(image: image, index: styleArray!)
//
//                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
//                let tempContext = CIContext(options: nil)
//                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
//                imageView.image = UIImage(cgImage: tempImage!)
//            } catch let error as NSError {
//                print("CoreML Model Error: \(error)")
//            }
//        }
        
        guard let image = self.imageView.image else {
            print("Select an image first")
            return
        }
        
        self.isProcessing = true
        self.process(input: image) { filteredImage, error in
            self.isProcessing = false
            if let filteredImage = filteredImage {
                self.imageView.image = filteredImage
            } else if let error = error {
                self.showError(error)
            } else {
                self.showError(TWMNSTError.unknown)
            }
        }
    }
    
    //MARK: - Utils
    func showError(_ error: Error) {
        
    }

    //MARK:- CoreML
    func process(input: UIImage, completion: @escaping FilteringCompletion) {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        var outputImage: UIImage?
        var nstError: Error?
        
        // Next step is pretty heavy, better process it
        // asynchronously to prevent UI freeze
        DispatchQueue.global().async {
            
            // Load model and launch prediction
            do {
                let modelProvider = try self.selectedNSTModel.modelProvider()
                outputImage = try modelProvider.prediction(inputImage: input)
            } catch let error {
                nstError = error
            }
            
            // Hand result to main thread
            DispatchQueue.main.async {
                if let outputImage = outputImage {
                    completion(outputImage, nil)
                } else if let nstError = nstError{
                    completion(nil, nstError)
                } else {
                    completion(nil, TWMNSTError.unknown)
                }
                
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("Time elapsed for NST process: \(timeElapsed) s.")
            }
        }
    }
    //MARK:-  当风格发生变化的时候
    @IBAction func segmentedControlValueChanges(_ sender: Any) {
        self.selectedNSTModel = NSTDemoModel.allCases[self.segmentedControl.selectedSegmentIndex]
    }
    
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 256, height: 256), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 2
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 256, 256, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        // 3
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        // 4
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 256, height: 256, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // 5
        context?.translateBy(x: 0, y: 256)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showImagePicker(_ preview: Bool) {
        let config = ZLPhotoConfiguration.default()
        config.editImageClipRatios = [.custom, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)]
        
        config.imageStickerContainerView = TWMImageStickerContainerView()
        config.allowSelectImage = true
        config.maxSelectCount = 1
        config.allowEditImage = false
        
        
        // You can first determine whether the asset is allowed to be selected.
        config.canSelectAsset = { (asset) -> Bool in
            return true
        }
        
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                debugPrint("No library authority")
            case .camera:
                debugPrint("No camera authority")
            case .microphone:
                debugPrint("No microphone authority")
            }
        }
        
        let ac = ZLPhotoPreviewSheet(selectedAssets: self.selectedAssets)
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            self?.selectedImages = images
            self?.selectedAssets = assets
            self?.imageView.image = images[0]
            debugPrint("\(images)   \(assets)   \(isOriginal)")
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { (errorAssets, errorIndexs) in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
         
        ac.showPreview(animate: true, sender: self)
    }
}

 
