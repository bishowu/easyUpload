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
    
    init(id: String, title: String, asset: PHAssetCollection) {
        self.id = id
        self.title = title
        self.asset = asset
    }
}
