import SwiftUI

struct HouseDashboardView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Hi, \(appViewModel.currentUser?.name ?? "User") 👋")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            appViewModel.logout()
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("Here's your house today")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Today's Chores
                TodaysChoresCard(chores: appViewModel.sampleChores)
                    .padding(.horizontal, 24)
                
                // Weekly Leader & House Members Row
                HStack(spacing: 16) {
                    WeeklyLeaderCard(leader: appViewModel.weeklyLeader)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                // House Members
                HouseMembersCard(members: appViewModel.sampleUsers)
                    .padding(.horizontal, 24)
                
                // Spacer for floating button
                Spacer(minLength: 100)
            }
        }
        .overlay(
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Placeholder action for demo
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                            Text("New Chore")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 30)
                }
            }
        )
        .navigationBarHidden(true)
    }
}

struct TodaysChoresCard: View {
    let chores: [Chore]
    
    var todaysChores: [Chore] {
        chores.filter { $0.dueLabel == "Today" || $0.dueLabel == "Overdue" }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Chores")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(todaysChores) { chore in
                    ChoreRow(chore: chore)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ChoreRow: View {
    let chore: Chore
    
    var body: some View {
        HStack(spacing: 12) {
            // Status icon
            Image(systemName: chore.isDone ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .foregroundColor(chore.isDone ? .green : .secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chore.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .strikethrough(chore.isDone)
                    .foregroundColor(chore.isDone ? .secondary : .primary)
                
                Text("Assigned to \(chore.assignedTo.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // User avatar
            UserAvatar(user: chore.assignedTo, size: 32)
            
            // Due label
            Text(chore.dueLabel)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(dueColor.opacity(0.2))
                .foregroundColor(dueColor)
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
    
    private var dueColor: Color {
        switch chore.dueLabel {
        case "Overdue":
            return .red
        case "Today":
            return .orange
        default:
            return .blue
        }
    }
}

struct WeeklyLeaderCard: View {
    let leader: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week's Leader")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                UserAvatar(user: leader, size: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(leader.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(leader.points) pts")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct HouseMembersCard: View {
    let members: [User]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("House Members")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(members) { member in
                        VStack(spacing: 8) {
                            UserAvatar(user: member, size: 50)
                            
                            Text(member.name)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct UserAvatar: View {
    let user: User
    let size: CGFloat
    
    var body: some View {
        Text(user.initials)
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(Color.blue)
            .clipShape(Circle())
    }
}

#Preview {
    HouseDashboardView()
        .environmentObject(AppViewModel())
}