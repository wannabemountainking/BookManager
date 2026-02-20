//
//  BookViewModel.swift
//  BookManager
//
//  Created by YoonieMac on 2/21/26.
//

import Foundation
import CoreData
import Combine

// 이 viewModel의 주 역할은 coredata에서 CRUD작업을 시키는 것 따라서 주요 property는 선택된 book과 sqlite에 book 데이터가 있는 지에 따라 C 인지 U인지 결정하는 isNew 임
final class BookViewModel: ObservableObject {
    
    // 무엇을 관찰해야 할까? @Published
    @Published var book: Book
    @Published var isNew: Bool
    
    // 여기서 주요 할 일은 무엇인가? core data
    let provider: BookProvider
    var context: NSManagedObjectContext
    
    init(provider: BookProvider, book: Book? = nil) {
        self.provider = provider
        self.context = provider.newContext
        
        if let book, let existingBook = provider.exist(context: context, book: book) {
            self.book = existingBook
            self.isNew = false
        } else {
            self.book = Book.empty(context: context)
            self.isNew = true
        }
    }
}
