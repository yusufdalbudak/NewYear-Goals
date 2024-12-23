import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [Goal]
    @State private var selectedFilter: GoalFilter = .all
    @State private var selectedGoal: Goal?
    @StateObject private var windowManager = WindowManager.shared
    let sharedModelContainer: ModelContainer
    
    enum GoalFilter {
        case all, active, completed
    }
    
    var filteredGoals: [Goal] {
        switch selectedFilter {
        case .all:
            return goals
        case .active:
            return goals.filter { !$0.isCompleted }
        case .completed:
            return goals.filter { $0.isCompleted }
        }
    }
    
    var overallProgress: Double {
        let totalGoals = goals.count
        guard totalGoals > 0 else { return 0 }
        return Double(goals.filter { $0.isCompleted }.count) / Double(totalGoals)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                ProgressOverviewCard(progress: overallProgress)
                    .padding()
                
                FilterSegmentedControl(selectedFilter: $selectedFilter)
                    .padding(.horizontal)
                
                List(filteredGoals, selection: $selectedGoal) { goal in
                    NavigationLink(value: goal) {
                        GoalRowView(goal: goal)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .background(Material.regular)
            }
            .navigationTitle("New Year Goals 🎄")
            .toolbar {
                ToolbarItem {
                    Button(action: { openNewGoalWindow() }) {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let goal = selectedGoal {
                GoalDetailView(goal: goal)
            } else {
                Text("Select a goal")
            }
        }
    }
    
    private func openNewGoalWindow() {
        WindowManager.shared.createWindow(
            title: "Add New Goal",
            content: AddGoalView()
                .environment(\.modelContext, modelContext)
                .modelContainer(sharedModelContainer)
        )
    }
    
    private func deleteGoals(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredGoals[index])
            }
        }
    }
}

// MARK: - Window Manager
final class WindowManager: NSObject, ObservableObject {
    static let shared = WindowManager()
    private var windowControllers: [UUID: NSWindowController] = [:]
    
    func createWindow<Content: View>(
        id: UUID = UUID(),
        title: String,
        content: Content
    ) where Content: View {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 600),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = title
        window.center()
        window.contentView = NSHostingView(rootView: 
            NavigationStack {
                content
                    .frame(minWidth: 480, minHeight: 600)
            }
        )
        
        let controller = NSWindowController(window: window)
        windowControllers[id] = controller
        controller.showWindow(nil)
    }
}

extension WindowManager: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if let id = windowControllers.first(where: { $0.value.window == window })?.key {
            windowControllers.removeValue(forKey: id)
        }
    }
}

// MARK: - Supporting Views
struct ProgressOverviewCard: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Overall Progress")
                .font(.headline)
            
            Text("\(Int(progress * 100))%")
                .font(.title)
                .bold()
            
            ProgressView(value: progress)
                .tint(.red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Material.regular)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct FilterSegmentedControl: View {
    @Binding var selectedFilter: ContentView.GoalFilter
    
    var body: some View {
        Picker("Filter", selection: $selectedFilter) {
            Text("All").tag(ContentView.GoalFilter.all)
            Text("Active").tag(ContentView.GoalFilter.active)
            Text("Completed").tag(ContentView.GoalFilter.completed)
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Goal.self, configurations: config)
        let sampleGoal = Goal(
            title: "Read Books",
            category: .education,
            description: "Read more books this year",
            dueDate: Date(),
            targetAmount: 12
        )
        container.mainContext.insert(sampleGoal)
        return ContentView(sharedModelContainer: container)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
} 
