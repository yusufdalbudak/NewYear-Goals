import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    let goal: Goal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Progress Section
                ProgressSection(goal: goal)
                
                // Details Section
                DetailsSection(goal: goal)
                
                // Update Progress Section
                UpdateProgressSection(goal: goal)
            }
            .padding()
        }
        .navigationTitle(goal.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            #else
            ToolbarItem {
                Menu {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            #endif
        }
        .alert("Delete Goal", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteGoal()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this goal?")
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                EditGoalView(goal: goal)
            }
        }
    }
    
    private func deleteGoal() {
        modelContext.delete(goal)
        dismiss()
    }
}

// Progress Section
private struct ProgressSection: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.headline)
            
            ProgressView(value: goal.progress) {
                HStack {
                    Text("\(goal.currentAmount) / \(goal.targetAmount)")
                    Spacer()
                    Text("\(Int(goal.progress * 100))%")
                }
                .font(.caption)
            }
            .tint(.red)
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// Details Section
private struct DetailsSection: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.headline)
            
            DetailRow(title: "Category", value: goal.category.rawValue)
            DetailRow(title: "Due Date", value: goal.dueDate.formatted(date: .long, time: .omitted))
            DetailRow(title: "Description", value: goal.goalDescription)
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
        }
    }
}

// Update Progress Section
private struct UpdateProgressSection: View {
    let goal: Goal
    @State private var amount: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Update Progress")
                .font(.headline)
            
            HStack {
                TextField("Amount", text: $amount)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .textFieldStyle(.roundedBorder)
                
                Button("Update") {
                    if let newAmount = Int(amount) {
                        goal.currentAmount = newAmount
                        goal.updateProgress()
                        amount = ""
                    }
                }
                .disabled(amount.isEmpty)
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 