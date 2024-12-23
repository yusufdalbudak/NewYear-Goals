import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    let goal: Goal
    
    @State private var title: String
    @State private var category: GoalCategory
    @State private var goalDescription: String
    @State private var dueDate: Date
    @State private var targetAmount: String
    
    init(goal: Goal) {
        self.goal = goal
        _title = State(initialValue: goal.title)
        _category = State(initialValue: goal.category)
        _goalDescription = State(initialValue: goal.goalDescription)
        _dueDate = State(initialValue: goal.dueDate)
        _targetAmount = State(initialValue: String(goal.targetAmount))
    }
    
    var body: some View {
        Form {
            Section("Goal Details") {
                TextField("Title", text: $title)
                Picker("Category", selection: $category) {
                    ForEach(GoalCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                TextEditor(text: $goalDescription)
                    .frame(height: 100)
            }
            
            Section("Target") {
                TextField("Target Amount", text: $targetAmount)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle("Edit Goal")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveChanges() }
                    .disabled(title.isEmpty || targetAmount.isEmpty)
            }
        }
    }
    
    private func saveChanges() {
        guard let targetAmountInt = Int(targetAmount) else { return }
        
        goal.title = title
        goal.category = category
        goal.goalDescription = goalDescription
        goal.dueDate = dueDate
        goal.targetAmount = targetAmountInt
        goal.updateProgress()
        
        dismiss()
    }
} 