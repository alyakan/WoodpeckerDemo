//
//  ManagedObjectConvertible.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation
import CoreData

/// An object that wants to be convertible in a managed object should implement the `ObjectConvertible` protocol.
protocol ObjectConvertible {
    /// An identifier that is used to fetch the corresponding database object.
    var modelIdentifier: String? { get }
}

/// An `NSManagedObject` that wants to be converted from an `ObjectConvertible` object should implement the `ManagedObjectConvertible` protocol.
protocol ManagedObjectConvertible {
    /// An object which should implement the `ObjectConvertible` protocol.
    associatedtype T
    
    /// A String representing a URI that provides an archiveable reference to the object in Core Data.
    var identifier: String? { get }
    
    /// Insert an object in Core Data.
    ///
    /// - Parameters:
    ///   - object: The object to insert.
    ///   - context: The managed object context.
    static func insert(_ object: T, with context: NSManagedObjectContext)
    
    /// Update an object in Core Data.
    ///
    /// - Parameters:
    ///   - object: The object to update.
    ///   - context: The managed object context.
    static func update(_ object: T, with context: NSManagedObjectContext)
    
    /// Delete an object from Core Data.
    ///
    /// - Parameters:
    ///   - object: The object to delete.
    ///   - context: The managed object context.
    static func delete(_ object: T, with context: NSManagedObjectContext)
    
    /// Fetch all objects from Core Data.
    ///
    /// - Parameter context: The managed object context.
    /// - Returns: A list of objects.
    static func fetchAll(from context: NSManagedObjectContext) -> [T]
    
    /// Set the managed object's parameters with an object's parameters.
    ///
    /// - Parameter object: An object.
    func from(object: T)
    
    /// Create an object, populated with the managed object's properties.
    ///
    /// - Returns: An object.
    func toObject() -> T
}

/// Basic implementation of CRUD operations.
extension ManagedObjectConvertible where T: ObjectConvertible, Self: NSManagedObject {
    var identifier: String? {
        return objectID.uriRepresentation().absoluteString
    }
    
    static func insert(_ object: T, with context: NSManagedObjectContext) {
        guard object.modelIdentifier != nil else { return }
        
        let managedObject = Self(context: context)
        managedObject.from(object: object)
        
        do {
            try context.save()
        } catch {
            print("Something went wrong. \(error)")
        }
    }
    
    static func update(_ object: T, with context: NSManagedObjectContext) {
        guard let managedObject = get(object: object, with: context) else {
            return
        }
        
        managedObject.from(object: object)
        
        try? context.save()
    }
    
    static func delete(_ object: T, with context: NSManagedObjectContext) {
        guard let managedObject = get(object: object, with: context) else {
            return
        }
        
        context.delete(managedObject)
        
        try? context.save()
    }
    
    static func fetchAll(from context: NSManagedObjectContext) -> [T] {
        let request = NSFetchRequest<Self>(entityName: String(describing: self))
        request.returnsObjectsAsFaults = false
        
        do {
            let managedObjects = try context.fetch(request)
            return managedObjects.map { $0.toObject() }
        } catch {
            return [T]()
        }
    }
    
    private static func get(object: T, with context: NSManagedObjectContext) -> Self? {
        guard
            let identifier = object.modelIdentifier,
            let uri = URL(string: identifier),
            let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) else
        {
            return nil
        }
        
        do {
            return try context.existingObject(with: objectID) as? Self
        } catch {
            return nil
        }
    }
}
