//
//  File.swift
//  Giphy
//
//  Created by Sanjay Mali on 03/11/16.
//  Copyright © 2016 Sanjay. All rights reserved.
//

import Foundation
import SwiftyJSON
class GiphyModel{
    let source_tld:String?
    let username:String?
    let gif_Url:String?
 
    required init(json:JSON) {
        self.source_tld = json["source_tld"].string
        self.username = json["username"].string
        self.gif_Url = json["images","fixed_height_small","url"].string
        print("source_tld:\(source_tld)")
        print("Gif:\(gif_Url)")
        
    }
    
}
