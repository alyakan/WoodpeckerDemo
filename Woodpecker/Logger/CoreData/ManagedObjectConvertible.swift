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
    associatedtype T: ObjectConvertible
    
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
/// You can have a different implementation with Self is equal to something else (eg. Saving to disk and the modelIdentifier would be a filepath).
extension ManagedObjectConvertible where Self: NSManagedObject {
    static func insert(_ object: T, with context: NSManagedObjectContext) {
        // Check for model name.
        guard object.modelIdentifier != nil else { return }
        
        // Create a managed object using the context.
        let managedObject = Self(context: context)
        
        // Fill the data in the managed object from the given object.
        managedObject.from(object: object)
        
        // Try to save.
        do {
            try context.save()
        } catch {
            print("Something went wrong while inserting an object with identifier \(object.modelIdentifier ?? ""). \(error)")
        }
    }
    
    static func fetchAll(from context: NSManagedObjectContext) -> [T] {
        // Create a fetch request using a string description of the managed object's class name.
        let request = NSFetchRequest<Self>(entityName: String(describing: self))
        
        // Try to fetch managed objects.
        do {
            let managedObjects = try context.fetch(request)
            
            // Convert managed objects to normal objects using the ManagedObjectConvertible protocol.
            return managedObjects.map { $0.toObject() }
        } catch {
            return [T]()
        }
    }
    
    static func update(_ object: T, with context: NSManagedObjectContext) {
        /// Empty
    }
    
    static func delete(_ object: T, with context: NSManagedObjectContext) {
        /// Empty
    }
}
