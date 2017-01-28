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
   
    //MARK: - Outlet for collection cell
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: - Connect to AppDelegate for shared model
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sent Memes"

        //Set collection cell size and space
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        //Spacing on both sides
        flowLayout.minimumInteritemSpacing = space
        
        //Spacing on up and down
        flowLayout.minimumLineSpacing = space
        
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Connect to shared model
        memes = appDelegate.memes
        
        //Reload table view data
        self.collectionView?.reloadData()
    }

    // MARK: - Move to Make Meme
    @IBAction func moveMakeMeme(_ sender: Any) {
        let memesVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeMemeViewController") as! MakeMemeViewController
        
        //Connect memeVC with navigation view controller as rootView so that navigation bar can be seen
        let navController = UINavigationController(rootViewController: memesVC)
        self.present(navController, animated: true, completion: nil)
    }
  
    //MARK: - Collection view data source
    override  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
  
        let memesData = self.memes[indexPath.row]
        
        // Set the text and image
        cell.MemeCellImageView?.image = memesData.originalImage
        cell.topLabel?.text = memesData.topText
        cell.bottomLabel?.text = memesData.bottomText

        
        return cell
    }
    
    //MARK: - Collection view delegate
    //Move to Detail Meme
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        
        let memesData = self.memes[indexPath.row]
        
        detailController.memes = memesData
        
        self.navigationController!.pushViewController(detailController, animated: true)

    }


}
