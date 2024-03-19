//
//  ContentView.swift
//  ToDoList
//
//  Created by Shah, Om on 2/26/24.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var completed = false
}

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
        }
    }
    
    func addOrDeleteTask(title: String) {
        if title.isEmpty {
            let completedTaskIndices = tasks.indices.filter { tasks[$0].completed }
            tasks.remove(atOffsets: IndexSet(completedTaskIndices))
        } else {
            let newTask = Task(title: title)
            tasks.append(newTask)
        }
    }
}

struct ContentView: View {
    @StateObject var taskManager = TaskManager()
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "checkmark.seal")
                    .font(.largeTitle)
                
                
                Text("To-Do List")
                            .font(.largeTitle)
                            .padding(.bottom, 20)
                
                TextField("Enter task", text: $newTaskTitle)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10, style:.continuous).stroke(style: StrokeStyle(lineWidth: 2)))
                
                Button(action: {
                    taskManager.addOrDeleteTask(title: newTaskTitle)
                    newTaskTitle = "" // Clear the text field after adding task or deleting completed tasks
                }) {
                    if newTaskTitle.isEmpty {
                        Label("Delete Completed Tasks", systemImage: "trash")
                    } else {
                        Label("Add Task", systemImage: "plus")
                    }
                }
                .padding()
                
                List {
                    ForEach(taskManager.tasks) { task in
                        HStack {
                            Button(action: {
                                taskManager.toggleTaskCompletion(task: task)
                            }) {
                                Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text(task.title)
    
                            
                            Spacer()
                        }
                        
                    }
                }
          
                
            }
            .padding()
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
