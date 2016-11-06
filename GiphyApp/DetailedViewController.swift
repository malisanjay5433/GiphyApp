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
        let imageURL = UIImage.gifImageWithURL(self.image!)
        self.imageView.image = imageURL
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
