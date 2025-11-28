import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            currentView
                .id(currentViewId)
                .transition(currentTransition)
                .animation(.easeOut(duration: 0.4), value: currentViewId)
                .onChange(of: appViewModel.showCreateHouse) { _, _ in
                    // Trigger view update
                }
        }
    }
    
    private var currentView: some View {
        Group {
            if !appViewModel.isAuthenticated {
                OnboardingView()
            } else if appViewModel.showCreateHouse {
                CreateHouseView()
            } else if !appViewModel.hasSelectedHouse {
                HouseSelectionView()
            } else {
                HouseDashboardView()
            }
        }
    }
    
    private var currentViewId: String {
        if !appViewModel.isAuthenticated {
            return "onboarding"
        } else if appViewModel.showCreateHouse {
            return "createHouse"
        } else if !appViewModel.hasSelectedHouse {
            return "houseSelection"
        } else {
            return "dashboard"
        }
    }
    
    private var currentTransition: AnyTransition {
        if appViewModel.navigationDirection == .forward {
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        } else {
            return .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        }
    }
}