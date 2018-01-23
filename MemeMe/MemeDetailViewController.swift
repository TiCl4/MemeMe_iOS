//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Nguyen Tran on 1/21/18.
//  Copyright © 2018 Emperor. All rights reserved.
//

import UIKit

// MARK: - VillainDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
   // var memes: [Meme]!
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
      //  memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

