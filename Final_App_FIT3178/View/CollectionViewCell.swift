//
//  CollectionViewCell.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 09/05/2023.
//

import UIKit

class CollectionViewCell: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    static let identifier = "CollectionTableViewCell"
    
    
    //MARK: -initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder:NSCoder){
        fatalError()
    }
    
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.bounds
        
    }
    
    //MARK: -Collection View
    private let collectionView: UICollectionView = {
        //creates a collection view layout object
        let layout = UICollectionViewFlowLayout()
        //scroll direction of the grid
        layout.scrollDirection = .horizontal
        //margins used to lay out content in a section //creates an edge inset structure with specialised edges
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TileCollectionCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //hook to view model to be dynamic
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionCollectionViewCell.identifier, for: indexPath
            ) as? TileCollectionCollectionViewCell
        else {
            fatalError()
        }
        return cell
    }
}
