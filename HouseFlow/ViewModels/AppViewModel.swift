import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var hasSelectedHouse: Bool = false
    @Published var currentUser: User?
    @Published var houseName: String = ""
    
    // Sample data for demo
    let sampleUsers = [
        User(name: "Mahmut", points: 12),
        User(name: "Ali", points: 8),
        User(name: "Zeynep", points: 10),
        User(name: "Ayça", points: 6)
    ]
    
    var sampleChores: [Chore] {
        [
            Chore(title: "Take out the trash", assignedTo: sampleUsers[0], dueLabel: "Today"),
            Chore(title: "Clean kitchen counter", assignedTo: sampleUsers[1], dueLabel: "Today"),
            Chore(title: "Vacuum living room", assignedTo: sampleUsers[2], dueLabel: "Overdue"),
            Chore(title: "Clean bathroom", assignedTo: sampleUsers[3], dueLabel: "This week"),
            Chore(title: "Do laundry", assignedTo: sampleUsers[0], dueLabel: "Today", isDone: true)
        ]
    }
    
    var weeklyLeader: User {
        sampleUsers.max(by: { $0.points < $1.points }) ?? sampleUsers[0]
    }
    
    func authenticate() {
        isAuthenticated = true
        currentUser = sampleUsers[0] // Set Mahmut as current user for demo
    }
    
    func selectHouse(name: String) {
        houseName = name
        hasSelectedHouse = true
    }
    
    func logout() {
        isAuthenticated = false
        hasSelectedHouse = false
        currentUser = nil
        houseName = ""
    }
}