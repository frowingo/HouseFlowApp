import Foundation

struct Chore: Identifiable, Codable {
    let id = UUID()
    let title: String
    let assignedTo: User
    let dueLabel: String  // e.g. "Today", "Overdue", "This week"
    let isDone: Bool
    
    init(title: String, assignedTo: User, dueLabel: String, isDone: Bool = false) {
        self.title = title
        self.assignedTo = assignedTo
        self.dueLabel = dueLabel
        self.isDone = isDone
    }
}