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
    
    
    //MARK: - Connect to AppDelegate for shared model
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
 
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sent Memes"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Connect to shared model
        memes = appDelegate.memes
        
        //Reload table view data
        self.tableView.reloadData()
    }

    // MARK: - Move to Make Meme
    @IBAction func moveMakeMeme(_ sender: Any) {
        let memesVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeMemeViewController") as! MakeMemeViewController
        
        //Connect memeVC with navigation view controller as rootView so that navigation bar can be seen
        let navController = UINavigationController(rootViewController: memesVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        
        let memesData = self.memes[indexPath.row]
        
        //Set the text and image
        let topBottomText = "\(memesData.topText!)...\(memesData.bottomText!)"
        
        cell.tableCellLabel?.text = topBottomText
        cell.tableCellImage?.image = memesData.originalImage
        cell.topLabel?.text = memesData.topText
        cell.bottomLabel?.text = memesData.bottomText

        return cell
    }
    
    
    // MARK:- Table View Delegate
    //Move to Detail Meme
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        
        let memesData = self.memes[indexPath.row]
        
        detailController.memes = memesData
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //Delete select row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.appDelegate.memes.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
 

    
}
