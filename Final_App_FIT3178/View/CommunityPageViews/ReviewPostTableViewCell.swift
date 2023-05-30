//
//  ReviewPostTableViewCell.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 28/05/2023.
//

import UIKit

class ReviewPostTableViewCell: UITableViewCell {

    static let identifier = "ReviewPostTableViewCell"
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .brown
        // Set label properties as desired, such as font, text color, etc.
        return label
    }()
    
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .black
        // Set label properties as desired, such as font, text color, etc.
        return label
    }()
    
    private let reviewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        //fill entire cell
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(reviewImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(commentLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        reviewImage.frame = CGRect(x: (bounds.width - 200) / 2, y: titleLabel.frame.maxY + 10, width: 200, height: 200)
        let commentLabelHeight: CGFloat = 20
            let commentLabelWidth: CGFloat = bounds.width - 2 * 10
            let commentLabelX: CGFloat = 10
            let commentLabelY: CGFloat = reviewImage.frame.maxY + 10
            
        commentLabel.frame = CGRect(x: commentLabelX, y: commentLabelY, width: commentLabelWidth, height: commentLabelHeight)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImage.image = nil
        titleLabel.text = nil
        commentLabel.text = nil
    }
    
    
    public func configure(with model: UserPostViewModel){
        titleLabel.text = model.title
        
        if let data = model.photoData{
//            reviewImage.sd_setImage(with: model.photoData, completed: nil)
            reviewImage.image = UIImage(data:data)
        }
        commentLabel.text = model.comment
        
    }
}


class UserPostViewModel{
    //Represents a User Post
    
    let userId: String?
    let recipeId: Int
   // let photoURL: URL?
    let title: String?
    var photoData: Data?
    var comment: String?

    init( userId: String?, recipeId: Int,title: String?,photoData: Data?,comment: String?){
        self.userId = userId
        self.recipeId = recipeId
        self.comment = comment
        self.title = title
        self.photoData = photoData
    }

}
