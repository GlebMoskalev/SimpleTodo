//
//  TodoModel.swift
//  Todo#1
//
//  Created by Глеб Москалев on 25.04.2024.
//

import Foundation

class TodoModel{
    static let shared = TodoModel()
    
    private var todos = [TodoItem]()
    
    func loadTodos(){
        if let encodedData = UserDefaults.standard.array(forKey: "Todos") as? [Data]{
            todos = encodedData.compactMap({ try? JSONDecoder().decode(TodoItem.self, from: $0)})
        }
    }
    
    func saveTodos(){
        let data = todos.map({ try? JSONEncoder().encode($0)})
        UserDefaults.standard.set(data, forKey: "Todos")
    }
    
    func addTodo(todoName: String){
        todos.append(TodoItem(name: todoName))
        saveTodos()
    }
    
    func deleteTodo(at index: Int){
        todos.remove(at: index)
        saveTodos()
    }
    
    func toogleTodoCompletion(at index: Int){
        todos[index].isCompleted.toggle()
        saveTodos()
    }
    
    func getTodo(at index: Int) -> TodoItem{
        return todos[index]
    }
    
    func getAllTodos() -> [TodoItem]{
        return todos
    }
    
}
