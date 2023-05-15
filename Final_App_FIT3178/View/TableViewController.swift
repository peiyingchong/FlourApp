//
//  TableViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 09/05/2023.
//

import UIKit

class TableViewController: UIViewController , UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true

        // Do any additional setup after loading the view.
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    //tells data source to return number of rows in a given section of the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //ask the data source for a cell to insert in a particular location of the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { fatalError() }
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
