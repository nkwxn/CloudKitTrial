//
//  TodoViewModel.swift
//  TODOSync (iOS)
//
//  Created by Nicholas on 25/10/21.
//

import Foundation
import Combine

class TodoViewModel: ObservableObject {
    var cdModel = TodoStorage.shared
    
    @Published var todos: [TodoItem] = [] {
        didSet {
            print(todos)
        }
    }
    
    private var cancellable: AnyCancellable?
    
    init(
        todoPublisher: AnyPublisher<[TodoItem], Never> = TodoStorage.shared.todoItems.eraseToAnyPublisher()
    ) {
        cancellable = todoPublisher.sink { todoItems in
            print("memperbarui todo list")
            self.todos = todoItems
        }
    }
    
    func addNewItem(_ name: String) -> Void {
        cdModel.createTodo(name: name)
    }
    
    func deletItem(index offset: IndexSet) {
        offset.map {
            guard let id = todos[$0].id else { return }
            cdModel.deleteTodo(with: id)
        }
    }
}
