//
//  LocalAlbumTableViewController.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/29.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit

class LocalAlbumTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        LocalMedias.shared.loadAlbums {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LocalMedias.shared.getAlbums().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let albums = LocalMedias.shared.getAlbums()
        
        cell.labelFilename.text = albums[indexPath.row].title
        cell.labelStatus.text = "-"
        cell.btnAction.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let albums = LocalMedias.shared.getAlbums()
        if albums.count > indexPath.row {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
            
            vc.album = albums[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
