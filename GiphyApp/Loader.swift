//
//  Loader.swift
//  GiphyApp
//
//  Created by Sanjay Mali on 06/11/16.
//  Copyright © 2016 Sanjay. All rights reserved.
//
import UIKit
import KRProgressHUD
class Loader: NSObject {
   
   let appColor = UIColor().HexToColor("e8445c")
    
   private static var __once: () = {
        Static.instance = Loader()
    }()
    
    struct Static {
        static var onceToken: Int = 0
        static var instance: Loader? = nil
    }
    class var inst: Loader {
        
        _ = Loader.__once
        return Static.instance!
    }

    func startLoading(){
        KRProgressHUD.show()
        KRProgressHUD.set(activityIndicatorStyle: .color(appColor,.white))
    }
    
    func endLoading(){
        let delay = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delay) {
            KRProgressHUD.dismiss()
        }
    }
    
    func mask(){
         KRProgressHUD.set(.white
        )
    }
    
}
extension UIColor{
    
    func HexToColor(_ hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}


