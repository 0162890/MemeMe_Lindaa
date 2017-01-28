//
//  DetailMemeViewController.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 27..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var memeImageView: UIImageView!
   
    var memes : Meme?
    
    var popFlag = false
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Add right button to nagvigation bar 
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailMemeViewController.moveMakeMemeForEdit))
        
        //Set to the original size of the image
        memeImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        //Show meme image
        if let memeImage = memes?.memedImage{
            memeImageView.image = memeImage
        }
        
        //Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        //After Editng, back to tab bar view.
        if popFlag == true{
            self.navigationController!.popViewController(animated: false)
            popFlag = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Move to make meme for edit
    func moveMakeMemeForEdit(){
        let editContorller = self.storyboard?.instantiateViewController(withIdentifier: "MakeMemeViewController") as! MakeMemeViewController
        
        editContorller.editImage = memes?.originalImage
        editContorller.editTopText = memes?.topText
        editContorller.editBottomText = memes?.bottomText
        editContorller.editTopTextFontSize = memes?.topTextFontSize
        editContorller.editBottomTextFontSize = memes?.bottomTextFontSize
        
        //Use flags to distinguish between edit meme and make new meme
        editContorller.editFlag = true
        popFlag = true
        
        let navController = UINavigationController(rootViewController: editContorller)
        self.present(navController, animated: true, completion: nil)
        
    }

 
}
