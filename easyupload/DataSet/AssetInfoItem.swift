//
//  AssetInfoItem.swift
//  XnFun
//
//  Created by Justin on 2018/11/19.
//  Copyright © 2018年 ENIS. All rights reserved.
//

import UIKit
import Photos

class AssetInfoItem {
    /// 檔名
    var fileName: String
    /// 拍攝時間
    var createTime: String
    /// 檔案大小
    var fileSize: Int64
    /// PHAsset
    var phAsset: PHAsset
    /// 是否被選擇
    var selected: Bool
    /// 修改時間
//    var modificationTime: String
    var modifyTime: CLong
    /// PHAsset localIdentifier
    var id: String
    /// Duration
    var duration: String
    /// Thumbnail
    var thumbnail: UIImage?
    var isGIF: Bool
    
    init(id: String, fileName: String, createTime: String, fileSize: Int64, phAsset: PHAsset, modifyTime: CLong) {
        self.id = id
        self.fileName = fileName
        self.createTime = createTime
        self.fileSize = fileSize
        self.phAsset = phAsset
        self.selected = false
        self.modifyTime = modifyTime
        self.isGIF = false
        
        let s:Int = Int(phAsset.duration) % 60
        let m:Int = Int(phAsset.duration) / 60
        let h:Int = Int(phAsset.duration) / (60 * 60)
        self.duration = (h > 0) ? String(format: "%0d:%02d:%02d", h, m, s) : String(format: "%02d:%02d", m, s)
    }
    
    func getThumbnail(_ max: Int = 200) -> UIImage? {
        if nil == self.thumbnail || max != 200 {
            self.thumbnail = self.getImageFromAsset(asset: self.phAsset, size: CGSize(width: max, height: max), exactMode: false)
        }
        return self.thumbnail
    }
    
    /* (非同步) 利用PHAsset取得照片 */
   func getImageFromAsset(asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) ->()) {
        DispatchQueue.global().async {
            let imageRequestOptions = PHImageRequestOptions()
            imageRequestOptions.isSynchronous = false
            imageRequestOptions.deliveryMode = .highQualityFormat
           
            PHImageManager().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageRequestOptions) { (image, error) in
                completion(image)
            }
        }
   }
   
   /* (同步) 利用PHAsset取得照片 */
   func getImageFromAsset(asset: PHAsset, size: CGSize, exactMode: Bool = false) -> UIImage? {
        // 同步或非同步
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .highQualityFormat
       
        if exactMode {
            imageRequestOptions.resizeMode = .exact
        }
       
        var photo: UIImage?
        PHImageManager().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageRequestOptions) { (image, error) in
            photo = image
        }
        return photo
   }
}
