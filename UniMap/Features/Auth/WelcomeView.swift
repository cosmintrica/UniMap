import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @State private var showLocationPermission = false
    @State private var showRegistration = false
    
    private let pages = [
        WelcomePage(
            title: "Bun venit la UniMap",
            subtitle: "Navighează prin campus cu încredere",
            description: "Descoperă toate facilitățile universității tale cu hărți interactive și informații în timp real.",
            imageName: "map",
            color: Color.accentColor
        ),
        WelcomePage(
            title: "Hărți Detaliate",
            subtitle: "Explorează fiecare spațiu",
            description: "Găsește rapid sălile, laboratoarele și toate punctele de interes din campus.",
            imageName: "building.2",
            color: Color.green
        ),
        WelcomePage(
            title: "Informații Actualizate",
            subtitle: "Rămâi mereu la curent",
            description: "Primește notificări despre evenimente, modificări de orar și știri importante.",
            imageName: "bell",
            color: Color.orange
        ),
        WelcomePage(
            title: "Experiență Personalizată",
            subtitle: "Configurează-ți profilul",
            description: "Creează-ți contul pentru o experiență adaptată nevoilor tale specifice.",
            imageName: "person.circle",
            color: Color.purple
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean background - ensure it covers everything immediately
                Color(.systemBackground)
                    .ignoresSafeArea(.all)
                    .zIndex(0)
                
                VStack(spacing: 0) {
                    // Content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            WelcomeCardView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                    .zIndex(1)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                if value.translation.width > threshold && currentPage > 0 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage -= 1
                                    }
                                } else if value.translation.width < -threshold && currentPage < pages.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage += 1
                                    }
                                }
                            }
                    )
                    
                    // Bottom section
                    VStack(spacing: 32) {
                        // Page indicators
                        HStack(spacing: 6) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                                    .frame(width: index == currentPage ? 24 : 8, height: 4)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        
                        // Navigation buttons with enhanced animations
                        HStack(spacing: 12) {
                            if currentPage > 0 {
                                Button("Înapoi") {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        currentPage -= 1
                                    }
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(height: 44)
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                            }
                            
                            Spacer()
                            
                            Button(currentPage == pages.count - 1 ? "Începe" : "Continuă") {
                                if currentPage == pages.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showLocationPermission = true
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        currentPage += 1
                                    }
                                }
                            }
                            .accessibilityLabel(currentPage == pages.count - 1 ? "Începe aplicația" : "Continuă la următorul slide")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(minWidth: 120)
                            .background(
                                LinearGradient(
                                    colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 50))
                }
            }
        }
        .fullScreenCover(isPresented: $showLocationPermission) {
            LocationPermissionView(showRegistration: $showRegistration)
        }
        .fullScreenCover(isPresented: $showRegistration) {
            RegistrationView()
        }
    }
}

struct WelcomePage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let color: Color
}

struct WelcomeCardView: View {
    let page: WelcomePage
    @State private var isVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer(minLength: 60) // Moved icons down
                
                // Icon with enhanced animations - moved down
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(page.color.opacity(0.08))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isVisible)
                    
                    Image(systemName: page.imageName)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(page.color)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.4), value: isVisible)
                        // Special animation for bell icon (informații actualizate)
                        .rotationEffect(.degrees(page.imageName == "bell" && isVisible ? 360 : 0))
                        .animation(.easeInOut(duration: 1.0).delay(0.6), value: isVisible)
                }
                
                // Text content with perfect centering and staggered animations
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text(page.title)
                            .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .offset(y: isVisible ? 0 : 20)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                            .accessibilityAddTraits(.isHeader)
                            // Special animation for "Informații Actualizate" title
                            .scaleEffect(page.title.contains("Informații") && isVisible ? 1.05 : 1.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.8), value: isVisible)
                        
                        Text(page.subtitle)
                            .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .offset(y: isVisible ? 0 : 20)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: isVisible)
                    }
                    
                    Text(page.description)
                        .font(.system(size: min(geometry.size.width * 0.04, 17), weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, max(geometry.size.width * 0.1, 20))
                        .lineLimit(nil)
                        .minimumScaleFactor(0.7)
                        .offset(y: isVisible ? 0 : 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: isVisible)
                        // Special animation for "Informații Actualizate" description
                        .offset(x: page.title.contains("Informații") && isVisible ? 5 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(1.2), value: isVisible)
                }
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

#Preview {
    WelcomeView()
}
