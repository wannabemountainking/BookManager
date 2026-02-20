//
//  Book.swift
//  BookManager
//
//  Created by yoonie on 2/21/26.
//

import Foundation
import CoreData


final class Book: NSManagedObject, Identifiable {
    
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var publishedYear: Int
    @NSManaged var isRead: Bool
    
    var isValid: Bool {
        !title.isEmpty && !author.isEmpty
    }
}

extension Book {
    
    static func all() -> NSFetchRequest<Book> {
        let request: NSFetchRequest<Book> = NSFetchRequest(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
        return request
    }
    
    static func empty(context: NSManagedObjectContext) -> Book {
        Book(context: context)
    }
}
