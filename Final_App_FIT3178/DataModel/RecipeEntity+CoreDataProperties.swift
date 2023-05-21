//
//  RecipeEntity+CoreDataProperties.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 21/05/2023.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var serving: Double
    @NSManaged public var like: Int32
    @NSManaged public var readyTime: Int32
    @NSManaged public var summary: String?
    @NSManaged public var winePairing: String?
    @NSManaged public var image: Data?
    @NSManaged public var healthScore: Double

}

extension RecipeEntity : Identifiable {

}
