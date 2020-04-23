//
//  AlbumItem.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/29.
//  Copyright © 2020 Cecilia. All rights reserved.
//
import Photos

class AlbumItem {
    /// localIdentifier
    var id: String
    /// 相簿名稱
    var title: String
    /// PHAssetCollection
    var asset: PHAssetCollection
    /// Items in the album
    var assetInfoItems: [AssetInfoItem]
    /// Count
    var photoCount = 0
    var videoCount = 0
    
    init(id: String, title: String, asset: PHAssetCollection, items: PHFetchResult<PHAsset>) {
        self.id = id
        self.title = title
        self.asset = asset
        self.assetInfoItems = []
        
        let dateFormatter = DateFormatter()
        
        for i in 0..<items.count {
            let item = items[i]
            
            if item.mediaType == .image {
                photoCount += 1
            } else if item.mediaType == .video {
                videoCount += 1
            }
            
            // 取得asset更多資訊
            let id = item.value(forKey: "localIdentifier") as! String
            let fileName = item.value(forKey: "filename") as! String
            let creationDate = item.value(forKey: "creationDate") as! Date
            let createTime = dateFormatter.string(from: creationDate)
            let modificationDate = item.value(forKey: "modificationDate") as! Date
//                let modificationTime = dateFormatter.string(from: modificationDate)
            let fileSize = Int64(0) // File Size 排序時再更新數值
            self.assetInfoItems.append(AssetInfoItem(id: id, fileName: fileName, createTime: createTime, fileSize: fileSize,
                              phAsset: item, modifyTime: CLong(modificationDate.timeIntervalSince1970)))
        }
    }
}
