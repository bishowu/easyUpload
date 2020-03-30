//
//  UploadViewController.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskChangeObserver {
    
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        btnUpload.layer.borderColor = UIColor.systemBlue.cgColor
        btnUpload.layer.borderWidth = 1
        btnUpload.layer.cornerRadius = 20
        
        TaskManager.shared.setTaskChangeObserver(self)
    }
    
    @IBAction func btnUploadClick(_ sender: Any) {
        checkPhotoLibraryAuthority()
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
        
        TaskManager.shared.removeAllTasks()
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController {

            var rootViewController = UIApplication.shared.keyWindow!.rootViewController
            if rootViewController != nil {
                // Get the top ViewController
                while (rootViewController!.presentedViewController != nil) {
                    rootViewController = rootViewController!.presentedViewController!;
                }

                rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func checkPhotoLibraryAuthority() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            // 尚未決定
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.showSelectView()
                } else {
                    print("Warning: 未允許取用Album")
                    self.alertNoAuthorityToPhotoLibrary()
                }
            })
        } else if photos == .authorized {
            // 允許
            self.showSelectView()
        } else {
            // 其他
            self.alertNoAuthorityToPhotoLibrary()
        }
    }
    
    /* 顯示為取得存取相簿權限 */
    func alertNoAuthorityToPhotoLibrary() {
        let alert = UIAlertController(title: "Allow the Photo Permission", message: "Allow to access images/videos for upload", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        
        var rootViewController = UIApplication.shared.keyWindow!.rootViewController
        if rootViewController != nil {
            // Get the top ViewController
            while (rootViewController!.presentedViewController != nil) {
                rootViewController = rootViewController!.presentedViewController!;
            }

            rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSelectView() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalAlbumTableViewController") as! LocalAlbumTableViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TaskChangeObserver
    func onChanged(taskId: String, progress: Double?, status: TaskManager.TaskStatus) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskManager.shared.getAllTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        let tasks = TaskManager.shared.getAllTasks()
        let task = tasks[indexPath.row]
        let status = task.status
        let percentage = String(format: "%.02f", tasks[indexPath.row].percentage)
        let iCloudPhoto = tasks[indexPath.row].item.iCloudPhoto
        
        cell.labelFilename.text = "\(iCloudPhoto ? "iCloud - " : "")" + task.item.filename
        cell.labelStatus.text = status.rawValue + (status == .running ? " - \(percentage) %" : "")
        cell.id = task.id
        cell.status = (status == .pause) ? .pause : .play
        cell.delegate = self
        cell.btnAction.isHidden = (status == .success)
        
        return cell
    }
}

extension UploadViewController: TaskTableViewCellClick {
    func btnActionClick(id: String?, status: TaskTableViewCellStatus) {
        if let id = id {
            if status == .pause {
                TaskManager.shared.pauseTask(id)
            } else {
                TaskManager.shared.playTask(id)
            }
        }
    }
}
