//
//  ViewController.swift
//  MemeMe
//
//  Created by Nguyen Tran on 1/15/18.
//  Copyright © 2018 Emperor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    // Function to load album of saved images
    @IBAction func Album(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    private func imagePickerController(imagePicker : UIImagePickerController, didFinishPickingMediaWithInfo info : [String:Any]) {
        //loadPreviewImage(image)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(imagePicker : UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

