//
//  LocalMedias.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import Photos

class LocalMedias {
    public static let shared = LocalMedias()
    
    private var albumList = [AlbumItem]()
    private var assetInfoItems = [AssetInfoItem]()
    private var isLoadingMore = false
    
    init() {
    }
    
    func getAlbums() -> [AlbumItem] {
        return self.albumList
    }
    
    func getList() -> [AssetInfoItem] {
        return self.assetInfoItems
    }
    
    func getSelectedList() -> [AssetInfoItem] {
        return self.assetInfoItems.filter({ $0.selected })
    }
    
    func clearSelections() {
        for i in 0..<self.assetInfoItems.count {
            self.assetInfoItems[i].selected = false
        }
    }
    
    func loadAlbums(completionHandler: ()->()) {
        // 相簿（智能＋用戶創建）
        albumList.removeAll()
                
        // 列出所有系统的智能相簿
        let fetchOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
                    with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)
        self.processAssetCollection(collection: smartAlbums, isSmartAlbum: true)

        // 列出所有用户創建的相簿
        let userAlbums = PHAssetCollection.fetchAssetCollections(
                    with: .album, subtype: .albumRegular, options: fetchOptions)
        self.processAssetCollection(collection: userAlbums, isSmartAlbum: false)
    }
    
    func loadList(_ album: AlbumItem, completionHandler: ()->()) {
        
        guard !self.isLoadingMore else {
            completionHandler()
            return
        }
        
        self.assetInfoItems.removeAll()
        self.isLoadingMore = true
        
        // 取得PhotoLibrary裡所有照片與影片
        let assetsFetchResults = PHAsset.fetchAssets(in: album.asset , options: self.grabImageAndVideoSortByModifiDateDesc()) //PHAsset.fetchAssets(with: self.grabImageAndVideoSortByModifiDateDesc())
        let dateFormatter = DateFormatter()
        
        if assetsFetchResults.count > 0 {
            for i in 0 ..< (assetsFetchResults.count) {
                let pojo = assetsFetchResults[i]
                // 取得asset更多資訊
                let id = pojo.value(forKey: "localIdentifier") as! String
                let fileName = pojo.value(forKey: "filename") as! String
                let creationDate = pojo.value(forKey: "creationDate") as! Date
                let createTime = dateFormatter.string(from: creationDate)
                let modificationDate = pojo.value(forKey: "modificationDate") as! Date
                let modificationTime = dateFormatter.string(from: modificationDate)
                let fileSize = Int64(0) // File Size 排序時再更新數值
                self.assetInfoItems.append(
                    AssetInfoItem(id: id, fileName: fileName, createTime: createTime, fileSize: fileSize,
                                  phAsset: pojo, modificationTime: modificationTime))
            }
            
        }
        isLoadingMore = false
        completionHandler()
    }
    
    /* 抓取全部影片與照片，按修改時間倒著排序 */
    private func grabImageAndVideoSortByModifiDateDesc() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        // 按創建時間desc排
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        // 取得照片與影片
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        return fetchOptions
    }
    
    /* 處理獲取到的相簿 */
    private func processAssetCollection(collection:PHFetchResult<PHAssetCollection>, isSmartAlbum:Bool){
        
        for i in 0..<collection.count{
            // 取出相簿內的asset
            let c = collection[i]
            if !self.supportedSmartAlbum(c) {continue}
            
            // 没有asset的空相簿不顯示
//            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: self.grabImageAndVideoSortByModifiDateDesc())
//            if assetsFetchResult.count > 0 {
                let title = c.localizedTitle
                if isSmartAlbum {
                    if title != "" {
                        // 用原始英文相簿名，與備份頁相同
                        self.albumList.append(AlbumItem(id: c.localIdentifier, title: title!, asset: c))
                    }
                } else {
                    if let title = title, title != "" {
                        self.albumList.append(AlbumItem(id: c.localIdentifier, title: title, asset: c))
                    }
                }
//            }
        }
        
    }
    
    // Supported Smart Albums
    private func supportedSmartAlbum(_ album: PHAssetCollection) -> Bool {
        // Check if album is a SmartAlbum
        guard album.assetCollectionType == .smartAlbum else {
            return true
        }
        
        // Recently Deleted = 1000000201
        if album.assetCollectionSubtype.rawValue == 1000000201 || album.localizedTitle == NSLocalizedString("Smart_Album_Recently_Deleted", comment: "") {
            return false
        }
        
        // Check subtype
        switch (album.assetCollectionSubtype) {
        case .smartAlbumAllHidden:
            return false
        case .smartAlbumRecentlyAdded:
            return false
        default:
            break
        }
        
        return true
    }
}
