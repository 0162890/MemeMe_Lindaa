//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 25..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
    //appDelegate에 있는 memes와 연결
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        
        let memesData = self.memes[indexPath.row]
        
        // Set the name and image
        let topBottomText = "\(memesData.topText!)...\(memesData.bottomText!)"
        cell.textLabel?.text = topBottomText
        cell.textLabel?.textAlignment = .center
        
        //이미지 사이즈 정해서 올릴 때 쓰는 방법
//        let cellImg : UIImageView = UIImageView(frame: CGRect.init(x: 5, y: 5, width: 80, height: 80))
//        cellImg.image = UIImage(named: "memesData.memedImage")
//        cell.addSubview(cellImg)
        
        cell.imageView?.image = memesData.memedImage
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editController = self.storyboard?.instantiateViewController(withIdentifier: "makeMemeViewController") as! ViewController
        
        let memesData = self.memes[indexPath.row]
        
        
        
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
}
