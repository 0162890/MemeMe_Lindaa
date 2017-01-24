//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 18..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    


    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black, //테두리 색
        NSForegroundColorAttributeName: UIColor.white, //글자 색
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0]
    
    
    //저장할 미미 구조체
    struct Meme{
        var topText:String!
        var bottomText:String!
        var originalImage:UIImage!
        var memedImage:UIImage!
    }
    
    var naviRightButton : UIBarButtonItem!
    var naviLeftButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이미지 본래의 크기에 맞게 설정 
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.delegate = self
        bottomTextField.delegate = self
     
        //만들어 둔 Meme 속성 적용
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //문자 가운데 정렬
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center

        //textField를 이미지 뷰 앞으로 보내기
        topTextField.superview?.bringSubview(toFront: topTextField)
        bottomTextField.superview?.bringSubview(toFront: bottomTextField)

        
        //Nagivation bar에 버튼 추가
        naviLeftButton =  UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(ViewController.shareImage))
        naviRightButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = naviLeftButton
        navigationItem.rightBarButtonItem = naviRightButton
        
        //right button 사용 안됨 -> 이미지 선택 전까지
        naviLeftButton.isEnabled = false
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //카메라 사용 안되는 곳에서는 enable false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Subscribe to the keyboard notifications, to allow the view to raise when necessary
//        self.subscribeToKeyboardNotification()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: load image or take a picture
    
    //앨범에서 사진 선택
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    //Camera Roll -> 시뮬레이터에서는 사용 안됨
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }
    
    //선택한 이미지 이미지뷰에 뿌리기 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            //share button 가능
            naviLeftButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }

    //cancel버튼 누르면 앨범 내리기
    func imagePickerControllerDidCancel(_ picker : UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: save the Meme image
 
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //Meme 이미지 만들기
    func generateMemedImage() -> UIImage{
        
        //Hide toolbar and navbar
        self.navigationController?.isNavigationBarHidden = true
        toolBar.isHidden = true

        
        //afterScreenUpdates: true -> 캡쳐하는 효과
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.isNavigationBarHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    //share image -> Acitivity Controller
    func shareImage(_ sender: Any) {
        let image = generateMemedImage()
        let activityController = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        self.present(activityController, animated:true, completion: nil)
        
        //The completion handler to execute after the activity view controller is dismissed.
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            // Return if cancelled
            if (!completed) {
                return
            }
            //activity complete
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: keyboard : Delegate 사용
    
    //textfield 수정 시작시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //다시 클릭하면 써있던 텍스트 다 지우기
        textField.text = ""
        
        //bottomTextField이면, keyboard 위치 수정
        if textField == bottomTextField{
            //Subscribe to the keyboard notifications, to allow the view to raise when necessary
            self.subscribeToKeyboardNotification()
        }
    }
    
    //return 키 누르면
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //return 누르면 키보드 숨기기
        textField.resignFirstResponder()
        
        //bottomTextField이면, keyboard 위치 수정 원 위치
        if textField == bottomTextField{
            self.unsubscribeFromKeyboardNotifications()
        }
        
        return true;
    }

    
    //메인 뷰의 위치를 keyboard의 height 만큼 위로 올림
    func keyboardWillShow(_ notification:Notification){
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            print(self.view.frame.origin.y)
        }
    }
    
    //다시 내리기 
    func keyboardWillHide(_ notification:Notification){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += getKeyboardHeight(notification)
            print(self.view.frame.origin.y)

        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        //notification은 사용자의 정보를 가지고 있음
        let userInfo = notification.userInfo
        //userInfo의 keyboardframe 정보가 있음
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
    //keyboard가 appear한 것을 알려줌 : Notification을 이용
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    

}

