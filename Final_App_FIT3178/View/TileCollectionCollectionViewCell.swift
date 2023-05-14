//
//  TileCollectionCollectionViewCell.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 10/05/2023.
//

import UIKit

class TileCollectionCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
