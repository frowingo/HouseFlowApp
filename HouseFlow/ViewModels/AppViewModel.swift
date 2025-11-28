import Foundation
import Combine

enum NavigationDirection {
    case forward, backward
}

class AppViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var hasSelectedHouse: Bool = false
    @Published var showCreateHouse: Bool = false
    @Published var currentUser: User?
    @Published var houseName: String = ""
    @Published var chores: [Chore] = []
    @Published var navigationDirection: NavigationDirection = .forward
    
    // Sample data for demo
    let sampleUsers = [
        User(name: "Mahmut", points: 12),
        User(name: "Jane", points: 8),
        User(name: "Abdüllatif", points: 10),
        User(name: "Katya", points: 6)
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
        navigationDirection = .forward
        isAuthenticated = true
        currentUser = sampleUsers[0] // Set Mahmut as current user for demo
        initializeChores()
    }
    
    func selectHouse(name: String) {
        navigationDirection = .forward
        houseName = name
        hasSelectedHouse = true
        showCreateHouse = false
    }
    
    func showCreateHouseScreen() {
        navigationDirection = .forward
        showCreateHouse = true
    }
    
    func backToHouseSelection() {
        navigationDirection = .backward
        showCreateHouse = false
    }
    
    func createHouse(name: String, type: String, memberCount: Int) {
        navigationDirection = .forward
        houseName = name
        hasSelectedHouse = true
        showCreateHouse = false
    }
    
    func logout() {
        navigationDirection = .backward
        isAuthenticated = false
        hasSelectedHouse = false
        showCreateHouse = false
        currentUser = nil
        houseName = ""
        chores = []
    }
    
    private func initializeChores() {
        chores = [
            Chore(title: "Take out the trash", assignedTo: sampleUsers[0], dueLabel: "Today"),
            Chore(title: "Clean kitchen counter", assignedTo: sampleUsers[1], dueLabel: "Today"),
            Chore(title: "Vacuum living room", assignedTo: sampleUsers[2], dueLabel: "Overdue"),
            Chore(title: "Clean bathroom", assignedTo: sampleUsers[3], dueLabel: "This week"),
            Chore(title: "Do laundry", assignedTo: sampleUsers[0], dueLabel: "Today", isDone: true)
        ]
    }
    
    func toggleChoreCompletion(_ choreId: UUID) {
        if let index = chores.firstIndex(where: { $0.id == choreId }) {
            let currentChore = chores[index]
            var newChore = Chore(
                title: currentChore.title,
                assignedTo: currentChore.assignedTo,
                dueLabel: currentChore.dueLabel,
                isDone: !currentChore.isDone
            )
            chores[index] = newChore
        }
    }
}
