//
//  TaskViewModelFactory.swift
//  ToDoApp
//
//  Created by saurav sinha on 26/10/23.
//

import Foundation

final class TaskViewModelFactory {
    static func  createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
