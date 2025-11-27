import Foundation

struct User: Identifiable, Codable {
    let id = UUID()
    let name: String
    let initials: String
    let points: Int
    
    init(name: String, points: Int = 0) {
        self.name = name
        self.points = points
        
        // Generate initials from name
        let nameComponents = name.split(separator: " ")
        if nameComponents.count >= 2 {
            self.initials = String(nameComponents[0].prefix(1)) + String(nameComponents[1].prefix(1))
        } else {
            self.initials = String(name.prefix(2))
        }
    }
}