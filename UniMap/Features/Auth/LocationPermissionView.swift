import SwiftUI
import CoreLocation
import ObjectiveC

struct LocationPermissionView: View {
    @Binding var showRegistration: Bool
    @State private var locationManager = CLLocationManager()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            let delegate = LocationDelegate(showRegistration: $showRegistration, showingAlert: $showingAlert, alertMessage: $alertMessage)
            locationManager.delegate = delegate
            // Keep a strong reference to prevent deallocation
            objc_setAssociatedObject(locationManager, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        .alert("Eroare", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Subviews
    
    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.accentColor.opacity(0.08))
                .frame(width: 100, height: 100)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: true)
            
            Image(systemName: "location")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.accentColor)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: true)
        }
    }
    
    private func contentView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Permisiune pentru Locație")
                    .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text("Pentru o experiență optimă")
                    .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            
            Text("UniMap folosește locația ta pentru a-ți arăta cea mai apropiată clădire și pentru a-ți oferi direcții precise în campus.")
                .font(.system(size: min(geometry.size.width * 0.04, 17), weight: .regular, design: .default))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, max(geometry.size.width * 0.1, 20))
                .lineLimit(nil)
                .minimumScaleFactor(0.7)
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
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: true)
            
            Button("Continuă fără locație") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showRegistration = true
                }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.secondary)
            .frame(height: 44)
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
            withAnimation(.easeInOut(duration: 0.3)) {
                showRegistration = true
            }
        @unknown default:
            break
        }
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Binding var showRegistration: Bool
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String
    
    init(showRegistration: Binding<Bool>, showingAlert: Binding<Bool>, alertMessage: Binding<String>) {
        self._showRegistration = showRegistration
        self._showingAlert = showingAlert
        self._alertMessage = alertMessage
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            withAnimation(.easeInOut(duration: 0.3)) {
                showRegistration = true
            }
        case .denied, .restricted:
            alertMessage = "Permisiunea pentru locație a fost refuzată. Poți continua fără această funcționalitate."
            showingAlert = true
        default:
            break
        }
    }
}

#Preview {
    LocationPermissionView(showRegistration: .constant(false))
}
