//
//  Task.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import Foundation

struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createEmptyTask() -> Task {
        let lTaskList = Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
        return lTaskList
    }
    
    
//    static func createMockTaskList() -> [Task] {
//        let lTaskList = [
//                        Task(id: UUID(), name: "Go To Gym", description: "back workout", isCompleted: false, finishDate: Date()),
//                        Task(id: UUID(), name: "Car wash", description: "Downtown car wash center", isCompleted: false, finishDate: Date()),
//                        Task(id: UUID(), name: "Office Work", description: "Finish Picker module", isCompleted: true, finishDate: Date())
//                        ]
//        return lTaskList
//    }
}
