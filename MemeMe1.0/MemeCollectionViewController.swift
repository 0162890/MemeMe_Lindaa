//
//  MemeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 25..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController{
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
    //appDelegate에 있는 memes와 연결
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
    }

  
    override  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
  
        let memesData = self.memes[indexPath.row]
        
        // Set the name and image
        cell.MemeCellImageView?.image = memesData.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
        
    }


}
