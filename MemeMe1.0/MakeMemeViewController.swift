//
//  MakeMemeViewController.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 18..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class MakeMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    


    //MARK: - Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var textSizeStepper: UIStepper!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pictureButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
  
    
    //MARK: - Connect to AppDelegate for shared model
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK: - TextField Attributes
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    //MARK: - Flag for stepper to distinguish topTextField and bottomTextField
    var isTopText = true
    
    //MARK: - Properties for edit
    var editImage : UIImage?
    var editTopText : String?
    var editBottomText : String?
    var editTopTextFontSize : CGFloat?
    var editBottomTextFontSize : CGFloat?
    var editFlag : Bool = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.delegate = self
        bottomTextField.delegate = self
     
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center

        //Sending textField forward to imageView
        topTextField.superview?.bringSubview(toFront: topTextField)
        bottomTextField.superview?.bringSubview(toFront: bottomTextField)

        //Util add an image, share button disable
        shareButton.isEnabled = false
       
        //For stepper
        //if set to true stepping beyond maximumvalue will return to minimumvalue
        textSizeStepper.wraps = false
         //If set to true, the user pressing and holding on the stepper repeatedly alters value.
        textSizeStepper.autorepeat = true
        textSizeStepper.maximumValue = 60
        textSizeStepper.minimumValue = 25
        textSizeStepper.value = Double((topTextField.font?.pointSize)!)
       
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //If camera is not used, camera button disable
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Function call for edit
        if editFlag == true {
            setEditMeme()
            editFlag = false
        }
        
        //Hide tap bar
        self.tabBarController?.tabBar.isHidden = true
  
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show tap bar
        self.tabBarController?.tabBar.isHidden = false


    }
    
    // MARK: - Load image or take a picture
    
    //Load image
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    //Camera roll
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }
    
    //Cancel button
    func imagePickerControllerDidCancel(_ picker : UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Add selected image to image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
            //Share button enable
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Save the Meme image
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, topTextFontSize : topTextField.font!.pointSize, bottomTextFontSize : bottomTextField.font!.pointSize, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        self.appDelegate.memes.append(meme)
    }
    
    //Generate meme image
    func generateMemedImage() -> UIImage{
        
        //Hide toolbar
        self.toolBar.isHidden = true
        
        //Screenshot
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    //MARK:- Share image
    //Acitivity Controller for share
    @IBAction func shareImage(_ sender: Any) {
        let image = generateMemedImage()
        let activityController = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        self.present(activityController, animated:true, completion: nil)

        //The completion handler to execute after the activity view controller is dismissed.
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            //Activity complete : save meme
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
 
    // MARK: - Keyboard : Use TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Click to erase all the text only "Top" or "BOTTOM"
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
        //Stepper to topTextField
        if textField == topTextField{
            isTopText = true
            textSizeStepper.value = Double((topTextField.font?.pointSize)!)
        }
        
        //Stepper to bottomTextField
        if textField == bottomTextField{
            isTopText = false
            textSizeStepper.value = Double((bottomTextField.font?.pointSize)!)
            
            //If bottomTextField, edit keyboard location
            //Subscribe to the keyboard notifications, to allow the view to raise when necessary
            self.subscribeToKeyboardNotification()
        }
    }
    
    @IBAction func stepperTextSizeChanged(_ sender: UIStepper) {
        //Stepper to topTextField
        if isTopText == true{
            let stepperNum = Int(sender.value)
            topTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: CGFloat(stepperNum))
        }
            
        //Stepper to bottomTextField
        else{
            let stepperNum = Int(sender.value)
            bottomTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: CGFloat(stepperNum))
        }
    }
    
    
    //Press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        
        //If bottomTextField, edit keyboard origin location
        if textField == bottomTextField{
            self.unsubscribeFromKeyboardNotifications()
        }

        return true
    }

    
    //Raise the position of main view based on the height of the keyboard.
    func keyboardWillShow(_ notification:Notification){
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            print(self.view.frame.origin.y)
        }
    }
    
    //Lower the keyboard to its original position
    func keyboardWillHide(_ notification:Notification){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += getKeyboardHeight(notification)
            print(self.view.frame.origin.y)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        //Notification has user information
        let userInfo = notification.userInfo
        
        //UserInfo has keyboard height
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    //Notify keyboare appear : use Notification
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //Notify keyboare remove : use Notification
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Set image, textFields to edit
    func setEditMeme(){
        if let editImage = editImage{
            imagePickerView.image = editImage
        }
        if let editTopText = editTopText{
            topTextField.text = editTopText
        }
        if let editBottomText = editBottomText{
            bottomTextField.text = editBottomText
        }
        if let editTopTextFontSize = editTopTextFontSize{
            topTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: editTopTextFontSize)
        }
        if let editBottomTextFontSize = editBottomTextFontSize{
            bottomTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: editBottomTextFontSize)
        }
        shareButton.isEnabled = true
    }

    // Mark: - Cancel button
    @IBAction func cancelView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

