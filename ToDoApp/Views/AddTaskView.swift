//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by saurav sinha on 13/08/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel : TaskViewModel
    @State private var taskToAdd : Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var showAddTaskView: Bool
    @Binding var refreshTaskList: Bool
    @State private var showCheckAlert : Bool = false
    
    private var pickerDateRange : ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        
        let startDateComponent = DateComponents(year: currentDateComponent.year, month: currentDateComponent.month, day: currentDateComponent.day, hour: currentDateComponent.hour, minute: currentDateComponent.minute)
        
        let endDateComponent = DateComponents(year: 2024, month: 12, day: 31)
        
        return calendar.date(from: startDateComponent)!...calendar.date(from: endDateComponent)!
    }
    
    var body: some View {
     
        NavigationStack{
            List {
                Section(header: Text("TASK DETAIL")) {
                    TextField("Task Name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section(header: Text("TASK DATE/TIME")) {
                    DatePicker("Task Date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Cancel Button pressed")
                        if taskToAdd.name.isEmpty == false {
                            showCheckAlert.toggle()
                        } else {
                            showAddTaskView.toggle()
                        }
                        
                    } label: {
                        Text("Cancel")
                    }
                    .alert("Save Task?",
                           isPresented: $showCheckAlert) {
                        Button {
                            self.addTask()
                        } label: {
                            Text("Yes")
                        }

                        
                        Button {
                            showAddTaskView.toggle()
                        } label: {
                            Text("NO")
                        }
                        
                    } message: {
                        Text("Would you like to add this task \(taskToAdd.name)?")
                    }
                }
                
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Add Button pressed")
                        self.addTask()
                    } label: {
                        Text("Add")
                    }.disabled(taskToAdd.name.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        _ = self.taskViewModel.createNewTask(taskToAdd)
        self.refreshTaskList.toggle()
        showAddTaskView.toggle()
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModel(), showAddTaskView: .constant(false), refreshTaskList: .constant(false))
    }
}
