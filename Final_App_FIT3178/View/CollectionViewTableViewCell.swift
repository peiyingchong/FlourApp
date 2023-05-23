//
//  CollectionViewTableViewCell.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 22/05/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject{
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, recipe: RecipeData)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    private var recipe: [RecipeData] = [RecipeData]()
    
    weak var delegate: CollectionViewTableViewCellDelegate?

    static let identifier = "CollectionViewTableViewCell"
    
    //define a collection view
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //size of each cell
        layout.itemSize = CGSize(width: 130, height: 190)
        //horizontal scrolling
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //register collection view cell like the tableView
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .brown
        contentView.addSubview(collectionView)
        
        //conform to protocols that allow us to display pictures or data inside collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder:NSCoder){
        fatalError()
    }
    
    //need a frame
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with recipe: [RecipeData]){
        self.recipe = recipe
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
                    
    }

}
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return recipe.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.configure(with: recipe[indexPath.row].image, title: recipe[indexPath.row].title )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.CollectionViewTableViewCellDidTapCell(self, recipe: recipe[indexPath.row])
    }
}
