//
//  Constants.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

class Constants {
    //Константы
    static let shared = Constants()
    
    let redColor = UIColor(red: 0.99, green: 0.23, blue: 0.41, alpha: 1.0)
    let backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
    let tabBarBackgroundColor = UIColor.black.withAlphaComponent(0.3)
    let bleakRedColor = UIColor(red: 0.992, green: 0.227, blue: 0.412, alpha: 0.4)
    let redBGColor = UIColor(red: 252/255, green: 206/255, blue: 220/255, alpha: 1.0)
    
    let tableViewBackgroundColor = UIColor.red
    let tableCornerRadius = 25.0
    
    let categoryViewBackgroundColor = UIColor.red
    
    let collectionViewHeight: CGFloat = 112
    let collectionViewWidth: CGFloat = 330
    let collectionImageWidth: CGFloat = 300
    
    let dropdownControlHeight: CGFloat = 32
    let dropdownControlWidth: CGFloat = 200
    
    let leadingPadding: CGFloat = 16
    
    let categoryButtonWidth = 88
    let categoryButtonsHeight = 32
    
    let elementSpacing: CGFloat = 24
    let topDistance: CGFloat = 60
    
    let scrollViewHeight: CGFloat = 32
    let scrollViewWidth: CGFloat = 400
    
    let smallTextSize = 13.0
    let bigTextSize = 17.0
    
    let lightGrayTextColor = UIColor(red: 170/255, green: 170/255, blue: 173/255, alpha: 1.0)
    let priceColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
    
    let foodImagesHeight: CGFloat = 127
    let foodImagesWidth: CGFloat = 132
    
    let priceHeight: CGFloat = 32
    let priceWidth: CGFloat = 87
}
