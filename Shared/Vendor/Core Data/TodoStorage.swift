//
//  TodoStorage.swift
//  TODOSync (iOS)
//
//  Created by Nicholas on 25/10/21.
//

import SwiftUI
import CoreData
import Combine

// untuk membuat Core Data Stack
class TodoStorage: NSObject, ObservableObject {
    // CurrentValueSubject Combine
    var todoItems = CurrentValueSubject<[TodoItem], Never>([])
    
    // Fetch Controller, bisa buat yg lain2 nya juga hehehehe
    private var todoFetchController: NSFetchedResultsController<TodoItem>
    
    // SINGLETON WOI
    static let shared = TodoStorage()
    
    // CONTEXT BUAT SAVE DATA WOI
    var context = PersistenceController.shared.container.viewContext
    
    private override init() {
        // Sort Descriptor untuk melakukan sorting pada core data
        let todoSort = NSSortDescriptor(keyPath: \TodoItem.timestamp, ascending: true)
        let todoFR: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        todoFR.sortDescriptors = [todoSort]
        
        
        todoFetchController = NSFetchedResultsController(
            fetchRequest: todoFR,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        todoFetchController.delegate = self
        
        do {
            try todoFetchController.performFetch()
            todoItems.value = todoFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch TODO")
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("save error")
        }
    }
}

// MARK: - CRUD Todo List
extension TodoStorage {
    func createTodo(name: String) {
        let newTodo = TodoItem(context: PersistenceController.shared.container.viewContext)
        newTodo.id = UUID()
        newTodo.name = name
        newTodo.done = false
        newTodo.timestamp = Date()
        
        save()
    }
    
    func updateTodo(with id: UUID) {
        
    }
    
    func deleteTodo(with id: UUID) {
        let todoItem = todoItems.value.filter { item in
            item.id == id
        }
        context.delete(todoItem[0])
    }
}

// MARK: - NSFetchedResultController delegate methods
extension TodoStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let todoItems = controller.fetchedObjects as? [TodoItem] else { return }
        
        self.todoItems.value = todoItems
    }
}
