//
//  BannerCell.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 12/1/2567 BE.
//

import Foundation
import UIKit

class BannerCell: UICollectionViewCell {
    //Ячейка коллекции - картинка - баннер
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        // Configure image view constraints
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: Constants.shared.collectionImageWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.shared.collectionViewHeight).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with banner: Banner) {
        imageView.image = banner.image
    }
}
