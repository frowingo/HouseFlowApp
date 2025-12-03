import SwiftUI

struct HouseDashboardView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var selectedChore: Chore? = nil
    @State private var showChoreDetail = false
    @State private var showNewChore = false
    @State private var buttonState: NewChoreButtonState = .collapsed
    @State private var buttonTimer: Timer?
    @State private var showLogoutConfirmation = false
    
    enum NewChoreButtonState {
        case collapsed      // + icon, circle shape
        case expanded       // "New Chore" text, rounded rectangle
    }
    
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
                            showLogoutConfirmation = true
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
                
                // Announcements
                AnnouncementCard()
                    .padding(.horizontal, 24)
                
                // Today's Chores
                TodaysChoresCard(
                    chores: appViewModel.chores,
                    appViewModel: appViewModel,
                    onChoreDetailTap: { chore in
                        selectedChore = chore
                        showChoreDetail = true
                    }
                )
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
                    Button(action: handleNewChoreButtonTap) {
                        Group {
                            if buttonState == .collapsed {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.green, Color.green.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(Circle())
                            } else {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("New Chore")
                                        .font(.headline)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(28)
                            }
                        }
                        .scaleEffect(buttonState == .expanded ? 1.05 : 1.0)
                        .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 30)
                }
            }
        )
        .overlay(
            Group {
                if showChoreDetail, let chore = selectedChore {
                    ChoreDetailPopup(
                        chore: chore,
                        appViewModel: appViewModel,
                        onDismiss: {
                            showChoreDetail = false
                            selectedChore = nil
                        }
                    )
                }
                
                if showNewChore {
                    NewChorePopup(
                        appViewModel: appViewModel,
                        onDismiss: {
                            showNewChore = false
                            resetButtonState()
                        }
                    )
                }
                
                if showLogoutConfirmation {
                    LogoutConfirmationPopup(
                        onConfirm: {
                            showLogoutConfirmation = false
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appViewModel.logout()
                            }
                        },
                        onCancel: {
                            showLogoutConfirmation = false
                        }
                    )
                }
            }
        )
        .navigationBarHidden(true)
    }
    
    private func handleNewChoreButtonTap() {
        switch buttonState {
        case .collapsed:
            // First tap: expand button with stretch animation
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                buttonState = .expanded
            }
            startButtonTimer()
            
        case .expanded:
            // Second tap: show popup
            buttonTimer?.invalidate()
            showNewChore = true
        }
    }
    
    private func startButtonTimer() {
        buttonTimer?.invalidate()
        buttonTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                buttonState = .collapsed
            }
        }
    }
    
    private func resetButtonState() {
        buttonTimer?.invalidate()
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
            buttonState = .collapsed
        }
    }
}

struct TodaysChoresCard: View {
    let chores: [Chore]
    let appViewModel: AppViewModel
    let onChoreDetailTap: (Chore) -> Void
    
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
                    ChoreRow(
                        chore: chore,
                        onDetailTap: {
                            onChoreDetailTap(chore)
                        }
                    )
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
    let onDetailTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Status icon - fixed width column
            Image(systemName: chore.isDone ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .foregroundColor(chore.isDone ? .green : .secondary)
                .frame(width: 24)
            
            // Task title - flexible column
            Text(chore.title)
                .font(.body)
                .fontWeight(.medium)
                .strikethrough(chore.isDone)
                .foregroundColor(chore.isDone ? .secondary : .primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // User avatar - fixed width column
            UserAvatar(user: chore.assignedTo, size: 32)
                .frame(width: 32)
            
            // Status badge - fixed width column
            Text(chore.isDone ? "Done" : "Pending")
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(chore.isDone ? Color.green.opacity(0.2) : dueColor.opacity(0.2))
                .foregroundColor(chore.isDone ? .green : dueColor)
                .cornerRadius(8)
                .frame(width: 70)
            
            // Detail button - fixed width column
            Button(action: onDetailTap) {
                Image(systemName: "info.circle")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
            .frame(width: 24)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
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

struct AnnouncementCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.orange)
                
                Text("Announcements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("🎉 Welcome to HouseFlow!")
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("Keep your shared space organized by completing your assigned chores. Track progress and earn points!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            HStack {
                Spacer()
                Text("2 hours ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
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

struct ChoreDetailPopup: View {
    let chore: Chore
    let appViewModel: AppViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Popup content
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        Text("Chore Details")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                }
                
                // Chore info
                VStack(spacing: 16) {
                    // Task title and description
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text(chore.title)
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        
                        if !chore.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                
                                Text(chore.description)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Assigned person
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Assigned to")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                UserAvatar(user: chore.assignedTo, size: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(chore.assignedTo.name)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    
                                    Text("\(chore.assignedTo.points) points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Due date
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text(chore.dueLabel)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(dueColor.opacity(0.2))
                                .foregroundColor(dueColor)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                
                // Status control buttons
                VStack(spacing: 16) {
                    Text("Status")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 12) {
                        // Mark as Done button
                        Button(action: {
                            if !chore.isDone {
                                appViewModel.toggleChoreCompletion(chore.id)
                            }
                            onDismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text("Mark as Done")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(chore.isDone ? .secondary : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(chore.isDone ? Color.gray.opacity(0.2) : Color.green)
                            .cornerRadius(12)
                        }
                        .disabled(chore.isDone)
                        
                        // Mark as Pending button
                        Button(action: {
                            if chore.isDone {
                                appViewModel.toggleChoreCompletion(chore.id)
                            }
                            onDismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "clock.circle.fill")
                                    .font(.system(size: 16))
                                Text("Mark as Pending")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(!chore.isDone ? .secondary : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(!chore.isDone ? Color.gray.opacity(0.2) : Color.orange)
                            .cornerRadius(12)
                        }
                        .disabled(!chore.isDone)
                    }
                }
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 40)
        }
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

struct NewChorePopup: View {
    let appViewModel: AppViewModel
    let onDismiss: () -> Void
    @State private var choreName = ""
    @State private var choreDescription = ""
    @State private var selectedUser: User? = nil
    @State private var selectedDueLabel = "Today"
    
    let dueLabelOptions = ["Today", "Tomorrow", "This week", "Next week"]
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Popup content
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        Text("New Chore")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                }
                
                // Form fields
                VStack(spacing: 16) {
                    // Chore name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Name")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter task name", text: $choreName)
                            .font(.body)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Chore description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter task description", text: $choreDescription, axis: .vertical)
                            .font(.body)
                            .lineLimit(3...5)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Assign to user
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Assign To")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(appViewModel.sampleUsers, id: \.name) { user in
                                    Button(action: {
                                        selectedUser = user
                                    }) {
                                        VStack(spacing: 6) {
                                            UserAvatar(user: user, size: 40)
                                            Text(user.name)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedUser?.name == user.name ? 
                                            Color.blue.opacity(0.2) : Color.clear
                                        )
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    selectedUser?.name == user.name ? 
                                                    Color.blue : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Due date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach(dueLabelOptions, id: \.self) { option in
                                Button(action: {
                                    selectedDueLabel = option
                                }) {
                                    Text(option)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedDueLabel == option ? 
                                            Color.blue : Color(.systemGray5)
                                        )
                                        .foregroundColor(
                                            selectedDueLabel == option ? .white : .primary
                                        )
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: onDismiss) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button(action: createChore) {
                        Text("Create Chore")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(canCreateChore ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!canCreateChore)
                }
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 40)
        }
        .onAppear {
            selectedUser = appViewModel.sampleUsers.first
        }
    }
    
    private var canCreateChore: Bool {
        !choreName.isEmpty && selectedUser != nil
    }
    
    private func createChore() {
        guard let user = selectedUser, !choreName.isEmpty else { return }
        
        let newChore = Chore(
            title: choreName,
            description: choreDescription,
            assignedTo: user,
            dueLabel: selectedDueLabel
        )
        
        // Demo: Just add to current chores list
        appViewModel.chores.append(newChore)
        
        onDismiss()
    }
}

struct LogoutConfirmationPopup: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            // Popup content
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Confirm Logout")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Are you sure you want to logout? You will need to sign in again to access your house.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: onConfirm) {
                        Text("Yes, Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 60)
        }
    }
}

#Preview {
    HouseDashboardView()
        .environmentObject(AppViewModel())
}