//
//  TitleCollectionViewCell.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 22/05/2023.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Set label properties as desired, such as font, text color, etc.
        return label
    }()
    //need an image view to pass the image
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        //fill entire cell
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        
      
        //manually define the constraints for the title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //activating a set of layout constraints
            NSLayoutConstraint.activate([
                //aligns the left edge of the titleLabel with the left edge of the cell's contentView.
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                //aligns the right edge of the titleLabel with the right edge of the cell's contentView.
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                // aligns the bottom edge of the titleLabel with the bottom edge of the cell's contentView.
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
    }
    
    required init?(coder:NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeImageView.frame = contentView.bounds
    }
    
    public func configure( with imageURL:String, title:String){
        guard let url = URL(string: imageURL)else{
            return
        }
        //use asynchronous image downloading and caching techniques. One common approach is to use a library like SDWebImage to simplify the process -> import SDWebImage
        recipeImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = title
        titleLabel.textColor = .brown
        //sd_setImage method of UIImageView from SDWebImage asynchronously downloads the image from the given URL and sets it as the image property of the recipeImageView.
        //The completion closure parameter allows you to perform any additional tasks once the image is loaded, such as resizing or animation.
    }


}
