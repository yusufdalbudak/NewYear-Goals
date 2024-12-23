import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text(goal.category.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(4)
            }
            
            ProgressView(value: goal.progress) {
                HStack {
                    Text("\(goal.currentAmount) / \(goal.targetAmount)")
                    Spacer()
                    Text("\(Int(goal.progress * 100))%")
                }
                .font(.caption)
            }
            .tint(.red)
            
            HStack {
                Text(goal.dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if goal.isCompleted {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Material.regular)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

#Preview {
    GoalRowView(goal: Goal(
        title: "Read 12 Books",
        category: .education,
        description: "Read one book per month",
        dueDate: Date().addingTimeInterval(86400 * 365),
        targetAmount: 12,
        currentAmount: 3
    ))
    .padding()
    .modelContainer(for: Goal.self, inMemory: true)
} 