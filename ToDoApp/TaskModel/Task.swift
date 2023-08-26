//
//  Task.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import Foundation

struct Task {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createMockTaskList() -> [Task] {
        let lTaskList = [
                        Task(id: 1, name: "Go To Gym", description: "back workout", isCompleted: false, finishDate: Date()),
                        Task(id: 2, name: "Car wash", description: "Downtown car wash center", isCompleted: false, finishDate: Date()),
                        Task(id: 3, name: "Office Work", description: "Finish Picker module", isCompleted: true, finishDate: Date())
                        ]
        return lTaskList
    }
}
