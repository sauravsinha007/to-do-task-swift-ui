//
//  TaskRepository.swift
//  ToDoApp
//
//  Created by saurav sinha on 27/09/23.
//

import Foundation
import CoreData

protocol TaskRepository {
    func getTaskList(isCompleted: Bool) -> Result<[Task], TaskRepositoryError>
    func addTask(task: Task) -> Result<Bool, TaskRepositoryError>
    func updateTask(task: Task) -> Result<Bool, TaskRepositoryError>
    func deleteTask(task: Task) -> Result<Bool, TaskRepositoryError>
}


final class TaskRepositoryImplementation: TaskRepository {
    
    private let manageObjContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func getTaskList(isCompleted: Bool) -> Result<[Task], TaskRepositoryError> {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        print("DataBase Path: %@", paths)
        let lFetchRequest = TaskEntity.fetchRequest()
        lFetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        
        do{
            let lResult  = try manageObjContext.fetch(lFetchRequest)
            if lResult.isEmpty == false {
                let lTaskList = lResult.map({Task(id: $0.id!,
                                                  name: $0.name ?? "",
                                                  description: $0.taskDescription ?? "",
                                                  isCompleted: $0.isCompleted,
                                                  finishDate: $0.finishDate ?? Date())})
                return .success(lTaskList)
            }
            return .success([])
        } catch {
            print("\(self) \(#function) \(#line) error = \(String(describing: error.localizedDescription))")
            return .failure(.operationError("Error in fetching task list"))
        }
    }
    
    func addTask(task: Task) -> Result<Bool, TaskRepositoryError> {
        let lTaskEntity = TaskEntity(context: self.manageObjContext)
        lTaskEntity.id = UUID()
        lTaskEntity.taskDescription = task.description
        lTaskEntity.finishDate = task.finishDate
        lTaskEntity.isCompleted = task.isCompleted
        lTaskEntity.name = task.name
        
        do {
            try self.manageObjContext.save()
            return .success(true)
        } catch {
            self.manageObjContext.rollback()
            print("\(self) \(#function) \(#line) error = \(String(describing: error.localizedDescription))")
            return .failure(.operationError("Error in adding task, \(String(describing: error.localizedDescription))"))
        }
    }
    
    func updateTask(task: Task) -> Result<Bool, TaskRepositoryError> {
        let lFetchReq = TaskEntity.fetchRequest()
        lFetchReq.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            
            if let lExistingTask = try self.manageObjContext.fetch(lFetchReq).first {
                lExistingTask.name = task.name
                lExistingTask.isCompleted = task.isCompleted
                lExistingTask.finishDate = task.finishDate
                lExistingTask.taskDescription = task.description
                
                try self.manageObjContext.save()
                
                return .success(true)
            } else {
                self.manageObjContext.rollback()
                print("\(self) \(#function) \(#line) ---- no task to update having id = \(task.id)")
                return .failure(.operationError("Error in updating task"))
            }
            
        } catch {
            print("\(self) \(#function) \(#line) error = \(String(describing: error.localizedDescription))")
            return .failure(.operationError("Error in updating task, \(String(describing: error.localizedDescription))"))
        }
       
    }
    
    func deleteTask(task: Task) -> Result<Bool, TaskRepositoryError> {
        let lFetchReq = TaskEntity.fetchRequest()
        lFetchReq.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let lExistingTask = try self.manageObjContext.fetch(lFetchReq).first {
                self.manageObjContext.delete(lExistingTask)
                try self.manageObjContext.save()
                return .success(true)
            } else {
                print("\(self) \(#function) \(#line) ---- no task to delete having id = \(task.id)")
                return .failure(.operationError("Error in deleting task"))
            }
            
        } catch {
            print("\(self) \(#function) \(#line) error = \(String(describing: error.localizedDescription))")
            return .failure(.operationError("Error in deleting task, \(String(describing: error.localizedDescription))"))
        }
       
    }
    
}
