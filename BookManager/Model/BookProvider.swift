//
//  BookProvider.swift
//  BookManager
//
//  Created by YoonieMac on 2/21/26.
//

import Foundation
import CoreData


// core data Provider는 singlton
final class BookProvider {
    
    static let shared: BookProvider = BookProvider()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        let contextInThisApp = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contextInThisApp.persistentStoreCoordinator = container.persistentStoreCoordinator
        return contextInThisApp
    }
    
    private init() {
        // NSPersistentContainer는 서고 관리자. BookData.xcdatamodeld는 서고 도면. sqlite가 서고(우리는 이건 모름)
        container = NSPersistentContainer(name: "BookData")
        
        // newContext는 읽기(R), UI반영 담당, viewContext는 create, update, delete(CUD)담당 -> 읽기 / 쓰기 분리 CQQRS(Command Query Responsibility Segregation) 패턴-> 즉 Coordinator가 알아서 열쇠 지물쇠 역할을 함(직렬화 함. 그래서 우리가 굳이 semaphore 같은거 안써도 됨)
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { description, error in
            if let error {
                print("ERROR Loading Core Data: \(error)")
            } else {
                print("Successfully loaded Core Data: \(description)")
            }
        }
    }
    
    // ViewModel 초기화 시 provider와 context가 필요한데 viewContext를 newContext로 초기화 시 갈아끼우므로 newContext에 book이 온전히 올라와 있는지 확인용: 인터넷 도서관에서 가져온 book의 일련번호로 실제 도서관 창구에 이 책 있냐고 확인해서 있으면 가져오고 없으면 인터넷 도서관 서버나 사서가 잘못한 것이겠지요.
    func exist(context: NSManagedObjectContext, book: Book) -> Book? {
        try? context.existingObject(with: book.objectID) as? Book
    }
}
