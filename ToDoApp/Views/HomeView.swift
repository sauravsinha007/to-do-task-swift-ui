//
//  HomeView.swift
//  ToDoApp
//
//  Created by saurav sinha on 12/08/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel : TaskViewModel = TaskViewModel()
    @State private var pickerFilter : [String] = ["Active","Completed"]
    @State private var defaultPickerItem = "Active"
    @State private var showAddNewTaskView : Bool = false
    @State private var showTaskDetailView : Bool = false
    @State private var selectedTaskDetail : Task = Task(id: 0, name: "", description: "", isCompleted: true, finishDate: Date())
    @State private var refreshTaskList : Bool = true
    
    var body: some View {
        NavigationStack {
            
            Picker("Picker Filter", selection: $defaultPickerItem) {
                ForEach(pickerFilter, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultPickerItem) { newValue in
                    self.taskViewModel.getTasks(isCompleted: defaultPickerItem == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title)
                    HStack {
                        Text(task.description).font(.caption).fontWeight(.bold)
                        Spacer()
                        Text(task.finishDate.toString())
                    }
                } .onTapGesture {
                    selectedTaskDetail = task
                    showTaskDetailView.toggle()
                }
            }.onAppear{
                taskViewModel.getTasks(isCompleted: true)
            }.onChange(of: refreshTaskList, perform: { newValue in
                self.taskViewModel.getTasks(isCompleted: defaultPickerItem == "Active")
            })
            
            .listStyle(.plain)
                .navigationTitle("Home")
                
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("add new task")
                            self.showAddNewTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            
                .sheet(isPresented: $showAddNewTaskView) {
                    AddTaskView(taskViewModel: taskViewModel,
                                showAddTaskView: $showAddNewTaskView,
                                refreshTaskList: $refreshTaskList)
                }
                .sheet(isPresented: $showTaskDetailView) {
                    TaskDetailView(taskViewModel: taskViewModel,
                                   selectedTask: $selectedTaskDetail,
                                   showTaskDetailView: $showTaskDetailView,
                                   refreshTaskList: $refreshTaskList)
                }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
