//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Nguyen Tran on 1/15/18.
//  Copyright © 2018 Emperor. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(textField: topTextField, text: "TOP")
        configure(textField: bottomTextField, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        // Disable camera in case the device does not have a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Function to clear text when textField is tapped
    func textFieldDidBeginEditing (_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Function to dismiss keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Function for topText and bottomText
    func configure(textField: UITextField, text: String) {
        let attributes: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0,
            
            ]
        
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = attributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    // Function to create a memed image
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        hide(flag: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memed:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hide(flag: false)
        
        return memed
    }
    
    // Initialize meme when the user wants to share the image
    // Save the meme to shared appDelegate
    func save(memed: UIImage) {
        // Create the meme
        let memeMe = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memed)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(memeMe)
    }
    
    //hide toolbar and navigation bar
    func hide(flag:Bool){
        self.toolBar.isHidden = flag
    }
    
    // Move view up when keyboard covers the textField
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    // Return view to original position
    @objc func keyboardWillHide(_ notification:NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // Function to get keyboard's height in order to move view up
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // Function to load camera for taking pictures
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }

    
    // Function to load album of saved images
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ imagePicker : UIImagePickerController, didFinishPickingMediaWithInfo info : [String:Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(imagePicker : UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Function to share memed image
    @IBAction func shareMemedImage(_ sender: Any) {
        let image = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activity.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError)  in
            if (completed) {
                self.save(memed: image)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activity, animated: true, completion: nil)
    }
    
    // Function to cancel action
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

