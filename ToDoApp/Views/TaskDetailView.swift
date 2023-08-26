//
//  TaskDetailView.swift
//  ToDoApp
//
//  Created by saurav sinha on 13/08/23.
//

import SwiftUI

struct TaskDetailView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var selectedTask: Task
    @Binding var showTaskDetailView: Bool
    @Binding var refreshTaskList: Bool
    @State private var showDeleteAlert : Bool = false
    
    
    var body: some View {
        
        NavigationStack {
            List {
                Section(header: Text("TASK DETAIL")) {
                    TextField("Task Name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark Completed", isOn: $selectedTask.isCompleted)
                }
                
                Section(header: Text("TASK DATE/TIME")) {
                    DatePicker("Task Date", selection: $selectedTask.finishDate)
                }
                
                Section {
                    
                    Button {
                        print("Delete Btn Pressed")
                        showDeleteAlert.toggle()
                       
                    } label: {
                        Text("Delete Task")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .alert("Delete task?",
                       isPresented: $showDeleteAlert) {
                    Button {
                        print("Yes Btn Pressed")
                        self.deleteTask()
                    } label: {
                        Text("Yes")
                    }

                    Button(role: .destructive) {
                        showDeleteAlert.toggle()
                    } label: {
                        Text("No")
                    }

                } message: {
                    Text("Would you like to deleet the task \(selectedTask.name)?")
                }
                
                
            }.navigationTitle("Task Detail")
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("Cancel Btn Pressed")
                            showTaskDetailView.toggle()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Update Btn Pressed")
                            _ = self.taskViewModel.updateTask(selectedTask)
                            refreshTaskList.toggle()
                            showTaskDetailView.toggle()
                        } label: {
                            Text("Update")
                        }.disabled(selectedTask.name.isEmpty)
                    }
                }
        }
    }
    
    private func deleteTask() {
        _ = self.taskViewModel.deleteTask(selectedTask)
        refreshTaskList.toggle()
        showTaskDetailView.toggle()
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModel(),
                       selectedTask: .constant(Task.createMockTaskList().first!),
                       showTaskDetailView:  .constant(false), refreshTaskList: .constant(false))
    }
}
