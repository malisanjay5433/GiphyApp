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
import QuartzCore


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate  {
    var titleLabel = UILabel()
    var g_model = [GiphyModel]()
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var search_Bar:UITextField!
    @IBOutlet var backButton:UIButton!

    let searchedResults = [String]()
    var searchedText:String?
    var total_count = 0
    var offset = 0
    var didScrollOffset = 0
    var limit = 25
    var loadingMoreView:InfiniteScrollActivityView?
    override func viewDidLoad() {
        super.viewDidLoad()
         congfig()
         self.searchedText = "Animals"
         makeRequestPost()
         configure_Loading()
    }
    func congfig(){
        search_Bar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        self.search_Bar.isHidden = false
        self.search_Bar.layer.borderColor = UIColor.white.cgColor
        self.search_Bar.layer.borderWidth = 1
        self.search_Bar.textColor = UIColor.white
        self.search_Bar.layer.cornerRadius = 3.0
        self.search_Bar.layer.masksToBounds = true
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 16, left: 5, bottom: 10, right: 5)
        if let patternImage = UIImage(named: "Ufo") {
            view.backgroundColor = UIColor(patternImage: patternImage)
       }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            
            return
        }
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -self.collectionView.contentInset.top), animated:true)
        self.searchedText = textField.text!
        offset = 0
        makeRequestPost()
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
        let back = cell.viewWithTag(3) as! UIButton
        back.isHidden  = true
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = true
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.gray.cgColor
        cell.userImage.clipsToBounds = true
        
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.borderWidth = 1
        back.layer.cornerRadius = 15
        back.layer.masksToBounds = true
        
        cell.userImage.image = UIImage(named:"ic_logo")
        self.search_Bar.placeholder = "Search here"
        DispatchQueue.global(qos: .default).async {
        let gifURL = giphy_model.gif_Url
        let imageURL = UIImage.gifImageWithURL(gifURL!)
            cell.userImage.image = imageURL
        }
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = self.g_model[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.superview?.bringSubview(toFront: cell!)
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:[], animations: { () -> Void in
            cell?.frame = collectionView.bounds
            collectionView.isScrollEnabled = false
            let back = cell?.viewWithTag(3) as! UIButton
            back.isHidden  = false
            self.search_Bar.placeholder = "Giphy.com"
            back.addTarget(self, action: #selector(ViewController.backToMainView), for: .touchUpInside)
            }, completion: nil)
        
    }

    func backToMainView(){
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:[], animations: { () -> Void in
            
        let indexPaths = self.collectionView!.indexPathsForSelectedItems! as [NSIndexPath]
        self.collectionView.isScrollEnabled = true
        self.collectionView.reloadItems(at: indexPaths as [IndexPath])
        }, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //device screen size
        let width = UIScreen.main.bounds.size.width
        //calculation of cell size
        return CGSize(width: ((width / 2) - 16)   , height: 180)
    }

    func makeRequestPost(){
        Loader.inst.startLoading()
        let key = "api_key="+"dc6zaTOxFJmzC"
        let text = self.searchedText!
        let encodingText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let enCodingKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let limit =  "limit" + "=" + "\(self.limit)"
        let offset =  "offset" + "=" + "\(self.offset)"
        let api = "http://api.giphy.com/v1/gifs/search?q=" + encodingText! + "&" + enCodingKey! + "&" + offset + "&"  + limit
        Alamofire.request(api,method:.get)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                
                    if let json = response.data{
                    let json_Data = JSON(data:json)
                    if json_Data["meta","status"] == 200{
                        self.total_count = json_Data["pagination","total_count"].int!
                       let data = json_Data["data"].array!
                        for i in data{
                            let giphy = GiphyModel(json:i)
                            self.g_model.append(giphy)
                        }
                    
                        
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.offset += self.limit
                    Loader.inst.endLoading()

                })
        }
}
    func configure_Loading(){
        let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionView.addSubview(loadingMoreView!)
        var insets = collectionView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView.contentInset = insets
}
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = collectionView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
        if total_count > g_model.count && offset > didScrollOffset {
                didScrollOffset = offset
                let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                makeRequestPost()
            }
            
        }
    }
}
