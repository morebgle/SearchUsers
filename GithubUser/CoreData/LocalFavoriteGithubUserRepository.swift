//
//  LocalFavoriteGithubUserRepository.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
import CoreData

class LocalFavoriteGithubUserRepository: FavoriteUserUseCase {
    func favorite(id: Int) -> Observable<FavoriteUser> {
        return .empty()
    }
    
    
    
    
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteUsers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                                        if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") } })
        return container }()
    var context: NSManagedObjectContext { return self.persistentContainer.viewContext }
    
    
    
    
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> Observable<[T]> {
        do {
            let fetchResult = try self.context.fetch(request)
            return .just(fetchResult)
        } catch {
            print(error.localizedDescription)
            return .error(error)
        }
    }
    
    func insertFavoriteUser(user: FavoriteUser) -> Observable<FavoriteUser> {
        let favoriteUserEntity = NSEntityDescription.entity(forEntityName: "CDFavoriteUser", in: self.context)
        guard let entity = favoriteUserEntity else { return .error(NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey:"Entity가 없습니다."])) }
        
        
        let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
        managedObject.setValue(user.id, forKey: "id")
        managedObject.setValue(user.name, forKey: "name")
        managedObject.setValue(user.isFavorite, forKey: "isFavorite")
        managedObject.setValue(user.memo, forKey: "memo")
        managedObject.setValue(user.imageURL, forKey: "imageURL")
        do {
            try self.context.save()
            return .just(user)
        } catch {
            return .error(error)
        }
        
    }
    
    func updateFavoriteUser(user: FavoriteUser) -> Observable<FavoriteUser> {
        let fetchRequest = NSFetchRequest<CDFavoriteUser>(entityName: "CDFavoriteUser")
        let predicate = NSPredicate(format: "id = %d", user.id)
        fetchRequest.predicate = predicate
        guard let results = try? context.fetch(fetchRequest)  else {
            return .error(NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey:"Entity가 없습니다."]))
        }
        if let result = results.first {
            result.setValue(user.name, forKey: "name")
            result.setValue(user.isFavorite, forKey: "isFavorite")
            result.setValue(user.memo, forKey: "memo")
            result.setValue(user.imageURL, forKey: "imageURL")
            do {
                try self.context.save()
                return .just(user)
            } catch {
                return .error(error)
            }
        } else {
            return self.insertFavoriteUser(user: user)
        }
        
    }
    
    func favoriteUsers(search: String?) -> Observable<[FavoriteUser]> {
        let fetchRequest = NSFetchRequest<CDFavoriteUser>(entityName: "CDFavoriteUser")
        if let search = search, search != "" {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] '\(search)' AND isFavorite == TRUE")
        } else {
            fetchRequest.predicate = NSPredicate(format: "isFavorite == TRUE")
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let results = try context.fetch(fetchRequest)
            return .just(results.map({ $0.toFavoriteUser }))
        } catch {
            return .error(error)
        }
    }
    
    func favoriteUser(id: Int) -> Observable<FavoriteUser?> {
        let fetchRequest = NSFetchRequest<CDFavoriteUser>(entityName: "CDFavoriteUser")
        let predicate = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = predicate
        guard let results = try? context.fetch(fetchRequest)  else {
            return .just(nil)
        }
        return .just(results.first?.toFavoriteUser)
    }
    
    func favoriteToggle(user favoriteUser: FavoriteUser?) -> Observable<FavoriteUser?> {
        guard let favoriteUser = favoriteUser else { return .empty() }
        return updateFavoriteUser(user: favoriteUser.toggle()).map { $0 }
    }
    func favoriteUser(user: User) -> Observable<FavoriteUser?> {
        return favoriteUser(id: user.id).map { preUser -> FavoriteUser? in
            let favoriteUser: FavoriteUser
            if let unwrapUser = preUser {
                favoriteUser = unwrapUser
            } else {
                favoriteUser = FavoriteUser(id: user.id, name: user.login, isFavorite: false, memo: nil, imageURL: user.avatarURL)
            }
            return favoriteUser
        }
    }
    
    func save(user: FavoriteUser) -> Observable<FavoriteUser> {
        updateFavoriteUser(user: user)
    }
    
    
    
}
