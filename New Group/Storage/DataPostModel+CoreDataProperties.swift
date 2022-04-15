//
//  DataPostModel+CoreDataProperties.swift
//  Navigation
//
//  Created by Админ on 15.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import CoreData


extension DataPostModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataPostModel> {
        return NSFetchRequest<DataPostModel>(entityName: "DataPostModel")
    }
    
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var likes: String?
    @NSManaged public var views: String?
    @NSManaged public var postDescription: String?
}

extension DataPostModel : Identifiable {

}
