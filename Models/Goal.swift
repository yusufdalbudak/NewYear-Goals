import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var title: String
    var category: GoalCategory
    var goalDescription: String
    var dueDate: Date
    var progress: Double
    var targetAmount: Int
    var currentAmount: Int
    var createdAt: Date
    var isCompleted: Bool
    
    init(
        title: String,
        category: GoalCategory,
        description: String,
        dueDate: Date,
        targetAmount: Int,
        currentAmount: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.goalDescription = description
        self.dueDate = dueDate
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.progress = Double(currentAmount) / Double(targetAmount)
        self.createdAt = Date()
        self.isCompleted = false
    }
    
    // Progress'i güncellemek için yardımcı method
    func updateProgress() {
        self.progress = Double(currentAmount) / Double(targetAmount)
        self.isCompleted = currentAmount >= targetAmount
    }
}

enum GoalCategory: String, CaseIterable, Codable {
    case personal = "Personal"
    case health = "Health"
    case career = "Career"
    case education = "Education"
    case financial = "Financial"
    case other = "Other"
} 