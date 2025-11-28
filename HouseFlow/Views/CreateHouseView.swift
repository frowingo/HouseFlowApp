import SwiftUI

struct CreateHouseView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var houseName = ""
    @State private var selectedHouseType: HouseType = .studentHouse
    @State private var memberCount = 3
    
    enum HouseType: String, CaseIterable {
        case studentHouse = "Öğrenci Evi"
        case sharedHouse = "Paylaşımlı Ev"
        case dormRoom = "Yurt Odası"
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Header with back button
            VStack(spacing: 8) {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appViewModel.backToHouseSelection()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Text("Yeni Ev Oluştur")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Ev bilgilerinizi girerek başlayın")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            ScrollView {
                VStack(spacing: 32) {
                    // House Name Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ev İsmi")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Ev ismi girin", text: $houseName)
                                .font(.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(houseName.isEmpty ? Color.clear : Color.blue, lineWidth: 2)
                                )
                                .animation(.easeInOut(duration: 0.2), value: houseName.isEmpty)
                                .onChange(of: houseName) { _, newValue in
                                    if newValue.count > 30 {
                                        houseName = String(newValue.prefix(30))
                                    }
                                }
                            
                            if !houseName.isEmpty {
                                Text("\(houseName.count)/30 karakter")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // House Type Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ev Tipi")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 12) {
                            ForEach(HouseType.allCases, id: \.self) { type in
                                HouseTypeCard(
                                    type: type,
                                    isSelected: selectedHouseType == type
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedHouseType = type
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Member Count Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Kişi Sayısı")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            // Custom Train Track Slider
                            GeometryReader { geometry in
                                let padding: CGFloat = 22 // Padding from screen edges for bubble clearance
                                let sliderWidth = geometry.size.width - (padding * 2)
                                let stepWidth = sliderWidth / 6 // 6 intervals for 7 stops (2-8)
                                
                                ZStack {
                                    // Background rail (centered)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(.systemGray4))
                                        .frame(width: sliderWidth, height: 6)
                                    
                                    // Train stops (centered with rail)
                                    HStack(spacing: 0) {
                                        ForEach(Array(stride(from: 2, through: 8, by: 1)), id: \.self) { count in
                                            VStack(spacing: 0) {
                                                Rectangle()
                                                    .fill(Color(.systemGray3))
                                                    .frame(width: 3, height: 16)
                                                    .cornerRadius(1.5)
                                                
                                                Circle()
                                                    .fill(memberCount >= count ? Color.blue : Color(.systemGray4))
                                                    .frame(width: 10, height: 10)
                                                    .animation(.easeOut(duration: 0.2), value: memberCount)
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .frame(width: sliderWidth)
                                    
                                    // Floating bubble with number (perfect alignment)
                                    // Each stop gets equal space in HStack: sliderWidth / 7 stops
                                    // Center of each stop: (stopIndex * stopWidth) + (stopWidth / 2)
                                    let totalStops: CGFloat = 7 // We have 7 stops (2,3,4,5,6,7,8)
                                    let stopWidth = sliderWidth / totalStops
                                    let stopIndex = CGFloat(memberCount - 2) // 0-based index (2->0, 3->1, etc)
                                    let stopCenterFromLeft = (stopIndex * stopWidth) + (stopWidth / 2)
                                    let bubbleX = (geometry.size.width - sliderWidth) / 2 + stopCenterFromLeft
                                    
                                    VStack(spacing: 0) {
                                        // Bubble
                                        Text("\(memberCount)")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                Circle()
                                                    .fill(Color.blue)
                                                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 4)
                                            )
                                        
                                        // Bubble tail (triangle pointing down)
                                        Triangle()
                                            .fill(Color.blue)
                                            .frame(width: 14, height: 10)
                                            .offset(y: -1)
                                    }
                                    .position(x: bubbleX, y: 15)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: bubbleX)
                                }
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let clampedX = max(padding, min(geometry.size.width - padding, value.location.x))
                                            let normalizedPosition = (clampedX - padding) / sliderWidth
                                            let step = round(normalizedPosition * 6)
                                            let newCount = Int(step) + 2
                                            let clampedCount = max(2, min(8, newCount))
                                            
                                            if clampedCount != memberCount {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    memberCount = clampedCount
                                                }
                                            }
                                        }
                                )
                                .onTapGesture { location in
                                    let clampedX = max(padding, min(geometry.size.width - padding, location.x))
                                    let normalizedPosition = (clampedX - padding) / sliderWidth
                                    let step = round(normalizedPosition * 6)
                                    let newCount = Int(step) + 2
                                    let clampedCount = max(2, min(8, newCount))
                                    
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        memberCount = clampedCount
                                    }
                                }
                            }
                            .frame(height: 70)
                            
                            // Labels
                            HStack {
                                Text("Min")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("Max")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
            
            // Create Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    appViewModel.createHouse(
                        name: houseName,
                        type: selectedHouseType.rawValue,
                        memberCount: memberCount
                    )
                }
            }) {
                Text("Evi Oluştur")
                    .font(.headline)
                    .foregroundColor(isFormValid ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isFormValid ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(16)
                    .animation(.easeInOut(duration: 0.2), value: isFormValid)
            }
            .disabled(!isFormValid)
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .navigationBarHidden(true)
    }
    
    private var isFormValid: Bool {
        !houseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct HouseTypeCard: View {
    let type: CreateHouseView.HouseType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .blue)
                
                // Label
                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        switch type {
        case .studentHouse:
            return "graduationcap.fill"
        case .sharedHouse:
            return "house.fill"
        case .dormRoom:
            return "building.2.fill"
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    CreateHouseView()
        .environmentObject(AppViewModel())
}
