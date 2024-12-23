import SwiftUI
import SwiftData

struct AddGoalView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var title = ""
    @State private var category: GoalCategory = .personal
    @State private var goalDescription = ""
    @State private var dueDate = Date()
    @State private var targetAmount = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                Picker("Category", selection: $category) {
                    ForEach(GoalCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)
                
                TextEditor(text: $goalDescription)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            } header: {
                Text("Goal Details")
            }
            
            Section {
                TextField("Target Amount", text: $targetAmount)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            } header: {
                Text("Target")
            }
        }
        .padding()
        .frame(minWidth: 400)
        .navigationTitle("New Goal")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: cancelAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveGoal)
                    .keyboardShortcut(.return)
                    .disabled(title.isEmpty || targetAmount.isEmpty)
            }
        }
    }
    
    private func saveGoal() {
        guard let targetAmountInt = Int(targetAmount) else { return }
        
        let goal = Goal(
            title: title,
            category: category,
            description: goalDescription,
            dueDate: dueDate,
            targetAmount: targetAmountInt
        )
        
        modelContext.insert(goal)
        try? modelContext.save()
        closeWindow()
    }
    
    private func cancelAction() {
        closeWindow()
    }
    
    private func closeWindow() {
        if let window = NSApplication.shared.windows.first(where: { $0.title == "Add New Goal" }) {
            window.close()
        }
    }
} 