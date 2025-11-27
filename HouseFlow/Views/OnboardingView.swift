import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showAuth = false
    
    let onboardingPages = [
        OnboardingPage(
            title: "Track house chores easily",
            subtitle: "See what needs to be done today in one glance.",
            imageName: "house.fill"
        ),
        OnboardingPage(
            title: "Share responsibilities fairly",
            subtitle: "Assign chores to roommates and keep things balanced.",
            imageName: "person.2.fill"
        ),
        OnboardingPage(
            title: "Stay organized with reminders",
            subtitle: "Keep your shared home tidy without arguments.",
            imageName: "bell.badge.fill"
        )
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            // App Header
            VStack(spacing: 8) {
                Text("HouseFlow")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("Manage shared house chores fairly and easily")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            // Onboarding Pages
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    VStack(spacing: 30) {
                        Image(systemName: onboardingPages[index].imageName)
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 16) {
                            Text(onboardingPages[index].title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                            
                            Text(onboardingPages[index].subtitle)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 32)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 300)
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                showAuth = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .navigationDestination(isPresented: $showAuth) {
            AuthView()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
}

#Preview {
    OnboardingView()
}