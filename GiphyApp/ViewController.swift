//
//  ViewController.swift
//  GiphyApp
//
//  Created by Sanjay Mali on 06/11/16.
//  Copyright © 2016 Sanjay. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    var g_model = [GiphyModel]()
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var search_Bar:UITextField!

    let array = ["backImage","Ufo","backImage","Ufo","backImage","Ufo","backImage","Ufo","backImage","Ufo","backImage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        search_Bar.delegate = self
//        self.navigationItem.title = "Giphy.com"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 16, left: 5, bottom: 10, right: 5)
        if let patternImage = UIImage(named: "Ufo") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        makeRequestPost("funny")
    
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            return
        }
       // self.search_Bar.text = textField.text!
        makeRequestPost(textField.text!)
        print("Searched Text:\(textField.text)")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.returnKeyType = UIReturnKeyType.search
    }

    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return g_model.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! Giphy_Cell
        let giphy_model = self.g_model[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = true
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.gray.cgColor
        cell.userImage.clipsToBounds = true
        cell.userImage.image = UIImage(named:"ic_logo")

        DispatchQueue.global(qos: .default).async {
        let gifURL = giphy_model.gif_Url
        let imageURL = UIImage.gifImageWithURL(gifURL!)
            cell.userImage.image = imageURL
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "giphyData", sender: indexPath.row)
        let giphy_model = self.g_model[indexPath.row]

        let vc = self.storyboard!.instantiateViewController(withIdentifier: "giphyData") as! DetailedViewController
        vc.image = giphy_model.gif_Url
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //device screen size
        let width = UIScreen.main.bounds.size.width
        //calculation of cell size
        return CGSize(width: ((width / 2) - 16)   , height: 180)
    }

    
    
    func makeRequestPost(_ searchText:String){
        Loader.inst.startLoading()
        print("makesearch:\(searchText)")
        let key = "api_key="+"dc6zaTOxFJmzC"
        let encodingText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let enCodingKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let api = "http://api.giphy.com/v1/gifs/search?q=" + encodingText! + "&" + enCodingKey!
        print("api:\(api)")
        Alamofire.request(api,method:.get)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                
//                self.g_model.removeAll()
                if let json = response.data{
                    let json_Data = JSON(data:json)
                    print("JSONData:\(json_Data)")
                    if json_Data["meta","status"] == 200{
//                        self.total_count = json_Data["pagination","total_count"].int!
//                        self.count = json_Data["pagination","count"].int!
                        let data = json_Data["data"].array!
                        
                        if data.count > 0 {
                            self.g_model.removeAll(keepingCapacity: false)
                        }
                        for i in data{
                            let giphy = GiphyModel(json:i)
                            self.g_model.append(giphy)
                        }
                        
                    }
                }
                DispatchQueue.main.async(execute: {
                    //                    self.loadingMoreView?.stopAnimating()
                    //                    self.offset += self.limit
                    //                    print("offset,limit:\(self.offset,self.limit)")
                    self.collectionView?.reloadData()
                    Loader.inst.endLoading()

                })
        }
}
}
