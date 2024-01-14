//
//  MenuCell.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 13/1/2567 BE.
//

import Foundation
import UIKit

class MenuTableCell: UITableViewCell {
    private let titleLabel: UILabel = {
        //Заголовок
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.shared.bigTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        //Описание
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.shared.smallTextSize)
        label.textColor = Constants.shared.lightGrayTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cellImageView: UIImageView = {
        //Картинка
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        //Цена
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.shared.smallTextSize)
        label.textColor = Constants.shared.priceColor
        label.backgroundColor = UIColor.clear
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = Constants.shared.priceColor.cgColor
        label.clipsToBounds = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Добавление элементов
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(cellImageView)
        contentView.addSubview(priceLabel)
        
        //Констрейны
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.shared.leadingPadding),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.shared.leadingPadding),
            cellImageView.widthAnchor.constraint(equalToConstant: Constants.shared.foodImagesWidth),
            cellImageView.heightAnchor.constraint(equalToConstant: Constants.shared.foodImagesHeight),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: Constants.shared.leadingPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.shared.leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.shared.leadingPadding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: Constants.shared.leadingPadding),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.shared.leadingPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.shared.leadingPadding),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.shared.leadingPadding),
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.shared.leadingPadding),
            priceLabel.heightAnchor.constraint(equalToConstant: Constants.shared.priceHeight),
            priceLabel.widthAnchor.constraint(equalToConstant: Constants.shared.priceWidth),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.shared.leadingPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellData: MenuItem, image: UIImage?) {
        //Получение данных - картинки и строк
        titleLabel.text = cellData.name
        descriptionLabel.text = cellData.description
        if image != nil {
            cellImageView.image = image
        }
        priceLabel.text = "От \(cellData.price.description) р"
    }
}
