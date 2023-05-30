//
//  HomePageViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 25/04/2023.
//

import UIKit
import CoreLocation

enum Sections: Int{
    case TrendingRecipes = 0
    case GlutenFreeRecipes = 1
    case VeganRecipes = 2
}
class HomePageViewController: UIViewController{
    
    
    //header section titles
    let sectionTitles: [String] = ["Trending Recipes","Gluten Free Recipes","Vegan Recipes"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        //register custom view cell
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTable)
        homeTable.delegate = self
        homeTable.dataSource = self
        configureNavBar()
        
        let locationManager = CLLocationManager()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                    case .notDetermined, .restricted:
                    LocationManager.shared.requestLocation()
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "requestLocationAccessSegue", sender: self)
//                        }
                    case .denied:
                        print("denied")
                    case .authorizedAlways, .authorizedWhenInUse:
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    @unknown default:
                        break
                }
            } else {
                print("Location services are not enabled")
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "cloud")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    }

}
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource{
    
    //each section corresponds to one category
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    //inside one section, only need 1 row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //each cell as collection view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate  = self
        switch indexPath.section{
        case Sections.GlutenFreeRecipes.rawValue:
            APICaller.shared.getGlutenFreeRecipes{ result in
                switch result{
                case .success(let recipes):
                    cell.configure(with: recipes)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.VeganRecipes.rawValue:
            APICaller.shared.getVeganRecipes { result in
                switch result{
                case .success(let recipes):
                    cell.configure(with: recipes)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingRecipes.rawValue:
            APICaller.shared.popularRecipes { result in
                switch result{
                case .success(let recipes):
                    cell.configure(with: recipes)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            print("failed")
        }
        return cell
    }
    
    //height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //set titles for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //editing the header for each section
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{ return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .brown
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //make navigation bar stick to top whenever scroll down
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
    
    
}
extension HomePageViewController: CollectionViewTableViewCellDelegate{
    
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, recipe: RecipeData) {
        performSegue(withIdentifier: "toRecipeOverviewVC", sender: recipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeOverviewVC",
           let destination = segue.destination as? RecipeOverview_ViewController,
           let recipe = sender as? RecipeData {
            destination.id = recipe.id
            destination.titled = recipe.title
            destination.imageUrl = recipe.image
        }
    }
}
