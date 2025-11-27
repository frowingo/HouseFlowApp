import SwiftUI

struct HouseSelectionView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 8) {
                Text("Your House")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Create a new house or join an existing one")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // House Options
            VStack(spacing: 20) {
                Button(action: {
                    appViewModel.selectHouse(name: "Mahmut's House")
                }) {
                    HouseOptionCard(
                        title: "Create New House",
                        subtitle: "Start fresh with your roommates",
                        iconName: "plus.circle.fill",
                        backgroundColor: .blue
                    )
                }
                
                Button(action: {
                    appViewModel.selectHouse(name: "Mahmut's Flat")
                }) {
                    HouseOptionCard(
                        title: "Join Existing House",
                        subtitle: "Enter an invite code to join",
                        iconName: "person.2.circle.fill",
                        backgroundColor: .green
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct HouseOptionCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(backgroundColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    HouseSelectionView()
        .environmentObject(AppViewModel())
}