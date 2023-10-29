//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import Foundation

final class TaskViewModel: ObservableObject {
    
    @Published var tasks : [Task] = []
    private var tempTasks : [Task] = [] //Task.createMockTaskList()
    
    private let taskRepository : TaskRepository
    @Published var errorMsg : String = ""
    @Published var isGetttingError : Bool = false
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isCompleted: Bool) {
        let lResult  = self.taskRepository.getTaskList(isCompleted: isCompleted)
        switch lResult {
        case .success(let fetchTasks):
            self.errorMsg = ""
            tasks = fetchTasks
        case .failure(let failure):
            self.processToShowError(failure)
        }
        
       // tasks = tempTasks.filter({$0.isCompleted == !isCompleted})
    }
    
    func createNewTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        return self.processOperationResult(self.taskRepository.addTask(task: lTask))
        //return self.taskRepository.addTask(task: lTask)
//        guard let lTask = task else {
//            return false
//        }
//        let lId = Int.random(in: 4...1000)
//        let lAddTask = Task(id: UUID(),
//                            name: lTask.name,
//                            description: lTask.description,
//                            isCompleted: lTask.isCompleted,
//                            finishDate: lTask.finishDate)
//        tempTasks.append(lAddTask)
//        return true
    }
    
    func updateTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        return self.processOperationResult(self.taskRepository.updateTask(task: lTask))
//        return self.taskRepository.updateTask(task: lTask)
//        guard let lTask = task else {
//            return false
//        }
//        if let lIndex = tempTasks.firstIndex(where: {$0.id == lTask.id}) {
//            tempTasks[lIndex].name = lTask.name
//            tempTasks[lIndex].description = lTask.description
//            tempTasks[lIndex].isCompleted = lTask.isCompleted
//            tempTasks[lIndex].finishDate = lTask.finishDate
//            return true
//        }
//        return false
    }
    
    func deleteTask(_ task: Task?) -> Bool {
        guard let lTask = task else {
            return false
        }
        return self.processOperationResult(self.taskRepository.deleteTask(task: lTask))
//        return self.taskRepository.deleteTask(task: lTask)
//        guard let lTask = task else {
//            return false
//        }
//        if let lIndex = tempTasks.firstIndex(where: {$0.id == lTask.id}) {
//            tempTasks.remove(at: lIndex)
//            return true
//        }
//        return false
    }
    
    private func processToShowError(_ error: TaskRepositoryError?) {
        
        switch error {
        case .operationError(let errorStr):
            self.errorMsg = errorStr
            self.isGetttingError = true
        case .none:
            self.errorMsg = ""
        }
    }
    
    private func processOperationResult(_ result: Result<Bool, TaskRepositoryError>) -> Bool {
        switch result {
        case .success(let success):
            self.errorMsg = ""
            return success
        case .failure(let failure):
           self.processToShowError(failure)
            return false
        }
    }
}
