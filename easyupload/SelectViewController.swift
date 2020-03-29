//
//  SelectViewController.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit
import Photos

class SelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var album: AlbumItem!
    var loaded = false
    
    let checked: UIImage = UIImage(named: "check_blue")!
    let notcheck: UIImage = UIImage(named: "check_empty")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.register(UINib(nibName: "SelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectCollectionViewCell")
        self.collectionView.register(UINib(nibName: "EmptyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        LocalMedias.shared.loadList(album) {
            self.loaded = true
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnUploadClick(_ sender: Any) {
        let selected = LocalMedias.shared.getSelectedList()
        var items = [UploadItem]()
        
        for s in selected {
            // rename: According to the backup settings
            items.append(UploadItem(devId: "xnbay_deviceId", dest: "/Drive/C/Upload/", media: s, rename: true))
        }
        TaskManager.shared.uploadItems = items
        TaskManager.shared.run()
        LocalMedias.shared.clearSelections()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if LocalMedias.shared.getList().count > 0 {
            LocalMedias.shared.getList()[indexPath.row].selected = true
            let selectedCell = collectionView.cellForItem(at: indexPath) as! SelectCollectionViewCell
            selectedCell.imgCheck.image = checked
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if LocalMedias.shared.getList().count > 0 {
            LocalMedias.shared.getList()[indexPath.row].selected = false
            let selectedCell = collectionView.cellForItem(at: indexPath) as! SelectCollectionViewCell
            selectedCell.imgCheck.image = notcheck
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = LocalMedias.shared.getList().count
        return count == 0 ? 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let medias = LocalMedias.shared.getList()
        
        if medias.count == 0 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
            cell.label.text = self.loaded ? "NO DATA" : "LOADING..."
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCollectionViewCell", for: indexPath) as! SelectCollectionViewCell
            
            cell.imgBackground.image = medias[indexPath.row].getThumbnail()
            cell.imgCheck.image = medias[indexPath.row].selected ? checked : notcheck
            cell.type = (medias[indexPath.row].phAsset.mediaType == .video) ? .video : .image
            return cell
        }
        
    }
    
    // MARK: - UICollectionViewFlowLayout
    // NOTICE: Workable when set the Estimate Size = None of 'Collection View Flow Layout' of CollectionView in Storyboard
    // NOTICE: Spacing: Set the 'Mini Spacing' = 1 of 'Collection View Flow Layout' of CollectionView in Storyboard
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if LocalMedias.shared.getList().count > 0 {
            let width: CGFloat = self.view.bounds.width / 4 - 1 /* Spacing */
            return CGSize(width: width, height: width)
        } else {
            let naviH = self.navigationController?.navigationBar.bounds.height ?? 50 /*Navi height*/
            let statusBarH = UIApplication.shared.statusBarFrame.height
            let offset: CGFloat = naviH + statusBarH
            let width: CGFloat = self.view.bounds.width
            let height: CGFloat = self.view.bounds.height - offset
            
            return CGSize(width: width, height: height)
        }
        
    }
    
}
