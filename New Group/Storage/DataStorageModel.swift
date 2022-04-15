//
//  DataStorageModel.swift
//  Navigation
//
//  Created by Админ on 15.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import CoreData

class DataStorageModel {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveFavoritePost(post: Post) {
        
        let favoritePost = DataPostModel(context: viewContext)
        favoritePost.name = post.name
        favoritePost.postDescription = post.description
        favoritePost.image = post.image
        favoritePost.views = String(post.views)
        favoritePost.likes = String(post.likes)
        
        do {
            try viewContext.save()
            
        }
        catch let error {
            print(error)
        }
    }
    
    func dataPostToPost(post: DataPostModel) -> Post? {
       
        guard let name = post.name,
        let description = post.postDescription,
        let image = post.image,
        let views = post.views,
        let likes = post.likes else { return nil }
        
        let postModel = Post(image: image, name: name, likes: likes, views: views, description: description)

            return postModel
    }
    
    func getFavoritePosts() -> [DataPostModel] {
        let fetch: NSFetchRequest<DataPostModel> = DataPostModel.fetchRequest()
        do {
            return try viewContext.fetch(fetch)
        } catch {
            fatalError()
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
