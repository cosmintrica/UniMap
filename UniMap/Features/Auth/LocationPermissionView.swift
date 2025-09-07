import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @Binding var showRegistration: Bool
    @State private var locationManager = CLLocationManager()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @StateObject private var locationDelegate = LocationDelegate()
    @State private var isVisible = false
    @State private var showRegistrationDirectly = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color.accentColor.opacity(0.05),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Top spacing
                        Spacer()
                            .frame(height: max(geometry.size.height * 0.1, 60))
                        
                        // Icon with animation
                        iconView
                        
                        // Content with dynamic sizing
                        contentView(geometry: geometry)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: max(geometry.size.height * 0.1, 60))
                        
                        // Buttons
                        buttonsView
                            .padding(.horizontal, 32)
                            .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 50))
                    }
                }
            }
        }
        .onAppear {
            locationDelegate.setup(showRegistration: $showRegistration, showingAlert: $showingAlert, alertMessage: $alertMessage)
            locationManager.delegate = locationDelegate
            
            // Start animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    isVisible = true
                }
            }
        }
        .alert("Eroare", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showRegistrationDirectly) {
            RegistrationView()
        }
    }
    
    // MARK: - Subviews
    
    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.accentColor.opacity(0.08))
                .frame(width: 100, height: 100)
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isVisible)
            
            Image(systemName: "location")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.accentColor)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: isVisible)
        }
    }
    
    private func contentView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Locație")
                    .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .offset(y: isVisible ? 0 : 20)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                
                Text("Pentru o experiență optimă")
                    .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .offset(y: isVisible ? 0 : 20)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
            }
            
            Text("UniMap folosește locația ta pentru a-ți arăta cea mai apropiată clădire și pentru a-ți oferi direcții precise în campus.")
                .font(.system(size: min(geometry.size.width * 0.04, 17), weight: .regular, design: .default))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, max(geometry.size.width * 0.1, 20))
                .lineLimit(nil)
                .minimumScaleFactor(0.7)
                .offset(y: isVisible ? 0 : 20)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
        }
        .padding(.top, 40)
    }
    
    private var buttonsView: some View {
        VStack(spacing: 12) {
            Button("Permite accesul la locație") {
                requestLocationPermission()
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.8), value: isVisible)
            
            Button("Continuă fără locație") {
                continueWithoutLocation()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.secondary)
            .frame(height: 44)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.0), value: isVisible)
        }
    }
    
    private func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            alertMessage = "Pentru a folosi funcționalitatea de locație, te rugăm să activezi permisiunea în Setări."
            showingAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            // Navighează direct la înregistrare
            print("Location authorized, navigating to registration...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showRegistrationDirectly = true
            }
        @unknown default:
            break
        }
    }
    
    private func continueWithoutLocation() {
        showRegistrationDirectly = true
    }
}

// MARK: - LocationDelegate
class LocationDelegate: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var showRegistration = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private var showRegistrationBinding: Binding<Bool>?
    private var showingAlertBinding: Binding<Bool>?
    private var alertMessageBinding: Binding<String>?
    
    func setup(showRegistration: Binding<Bool>, showingAlert: Binding<Bool>, alertMessage: Binding<String>) {
        self.showRegistrationBinding = showRegistration
        self.showingAlertBinding = showingAlert
        self.alertMessageBinding = alertMessage
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location authorization changed to: \(status.rawValue)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized, navigating to registration...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Setează flag-ul pentru a declanșa navigarea directă
                self.showRegistrationBinding?.wrappedValue = true
            }
        case .denied, .restricted:
            alertMessage = "Permisiunea pentru locație a fost refuzată. Poți continua fără această funcționalitate."
            showingAlert = true
            alertMessageBinding?.wrappedValue = alertMessage
            showingAlertBinding?.wrappedValue = true
        default:
            break
        }
    }
}


#Preview {
    LocationPermissionView(showRegistration: .constant(false))
}
