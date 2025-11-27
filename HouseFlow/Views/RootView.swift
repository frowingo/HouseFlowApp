import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if !appViewModel.isAuthenticated {
                    OnboardingView()
                } else if !appViewModel.hasSelectedHouse {
                    HouseSelectionView()
                } else {
                    HouseDashboardView()
                }
            }
        }
    }
}