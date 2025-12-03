import Foundation

struct Chore: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let assignedTo: User
    let dueLabel: String  // e.g. "Today", "Overdue", "This week"
    let isDone: Bool
    
    init(title: String, description: String = "", assignedTo: User, dueLabel: String, isDone: Bool = false) {
        self.title = title
        self.description = description
        self.assignedTo = assignedTo
        self.dueLabel = dueLabel
        self.isDone = isDone
    }
}