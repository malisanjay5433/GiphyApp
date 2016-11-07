//
//  DetailedViewController.swift
//  GiphyApp
//
//  Created by Sanjay Mali on 06/11/16.
//  Copyright © 2016 Sanjay. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet var imageView:UIImageView!

    var image:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named:"noImage")
//        let imageURL = UIImage.gifImageWithURL(self.image!)
        let imageURL = UIImage.gifImageWithURL(self.image!)

        self.imageView.image = imageURL
    }
}
