//
//  TodoItem.swift
//  Todo#1
//
//  Created by Глеб Москалев on 23.04.2024.
//

import Foundation

struct TodoItem: Codable {
    var name: String
    var isCompleted = false
    var id: UUID = UUID()
}
