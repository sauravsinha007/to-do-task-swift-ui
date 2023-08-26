//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import Foundation

final class TaskViewModel: ObservableObject {
    
    @Published var tasks : [Task] = []
    private var tempTasks : [Task] = Task.createMockTaskList()
    
    func getTasks(isCompleted: Bool) {
        tasks = tempTasks.filter({$0.isCompleted == !isCompleted})
    }
    
    func createNewTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        let lId = Int.random(in: 4...1000)
        let lAddTask = Task(id: lId,
                            name: lTask.name,
                            description: lTask.description,
                            isCompleted: lTask.isCompleted,
                            finishDate: lTask.finishDate)
        tempTasks.append(lAddTask)
        return true
    }
    
    func updateTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        if let lIndex = tempTasks.firstIndex(where: {$0.id == lTask.id}) {
            tempTasks[lIndex].name = lTask.name
            tempTasks[lIndex].description = lTask.description
            tempTasks[lIndex].isCompleted = lTask.isCompleted
            tempTasks[lIndex].finishDate = lTask.finishDate
            return true
        }
        return false
    }
    
    func deleteTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        if let lIndex = tempTasks.firstIndex(where: {$0.id == lTask.id}) {
            tempTasks.remove(at: lIndex)
            return true
        }
        return false
    }
    
}
