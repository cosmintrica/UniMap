# UniMap - Development Plan

## 📋 Overview
UniMap este o aplicație iOS pentru navigarea prin campusurile universitare, oferind hărți interactive, informații în timp real și o experiență personalizată pentru studenți.

## 🎯 Vision & Goals
- **Navigare intuitivă** prin campusuri universitare
- **Informații actualizate** despre evenimente, orare și știri
- **Experiență personalizată** bazată pe profilul utilizatorului
- **Design Apple-style** minimalist și elegant
- **Accesibilitate completă** pentru toți utilizatorii

## 🏗️ Current Architecture

### Tech Stack
- **Platform**: iOS (SwiftUI)
- **Backend**: Supabase (Database + Auth + Storage)
- **Maps**: Custom map implementation
- **State Management**: @StateObject + @EnvironmentObject
- **Navigation**: TabView + NavigationView

### Database Schema
- `universities` - Lista universităților
- `faculties` - Facultățile fiecărei universități
- `specializations` - Specializările fiecărei facultăți
- `masters` - Programele de master
- `user_profiles` - Profilurile utilizatorilor
- `announcements` - Anunțuri și știri
- `map_files` - Fișierele de hărți (JSON + assets)

## 📱 Core Features (Current)

### ✅ Authentication & Onboarding
- [x] Welcome screens cu animații fluide
- [x] Location permission request
- [x] User registration cu date educaționale
- [x] Login/logout functionality
- [x] Profile management

### ✅ Map System
- [x] Interactive campus maps
- [x] Building navigation
- [x] Floor plans
- [x] Room search
- [x] Directions

### ✅ Announcements
- [x] Real-time announcements
- [x] Filter by study year
- [x] Category-based organization

### ✅ User Management
- [x] Profile creation
- [x] Educational data selection
- [x] Admin panel
- [x] Institution switching

## 🚀 Planned Features (Future Phases)

### Phase 1: Enhanced User Experience
- [ ] **Push Notifications**
  - Event reminders
  - Schedule changes
  - Important announcements
  - Location-based alerts

- [ ] **Advanced Search**
  - Global search across all content
  - Voice search integration
  - Search history
  - Smart suggestions

- [ ] **Favorites & Bookmarks**
  - Save favorite locations
  - Bookmark important announcements
  - Quick access to frequently used features

### Phase 2: Social Features
- [ ] **User Profiles**
  - Profile pictures
  - Bio and interests
  - Study groups
  - Friend connections

- [ ] **Study Groups**
  - Create/join study groups
  - Group chat
  - Shared schedules
  - Collaborative notes

- [ ] **Events & Activities**
  - Event creation and management
  - RSVP functionality
  - Event discovery
  - Calendar integration

### Phase 3: Advanced Navigation
- [ ] **AR Navigation**
  - Augmented reality directions
  - AR building identification
  - Real-time navigation overlay

- [ ] **Indoor Positioning**
  - Bluetooth beacons integration
  - WiFi-based positioning
  - Step-by-step indoor navigation

- [ ] **Accessibility Features**
  - Voice navigation
  - High contrast mode
  - Large text support
  - VoiceOver optimization

### Phase 4: Analytics & Insights
- [ ] **Usage Analytics**
  - Popular locations tracking
  - User behavior insights
  - Campus usage patterns

- [ ] **Personalized Recommendations**
  - Study location suggestions
  - Event recommendations
  - Route optimization

- [ ] **Admin Dashboard**
  - Real-time usage statistics
  - Content management
  - User engagement metrics

## 🎨 Design System

### Color Palette
- **Primary**: `Color.accentColor` (adaptive to light/dark mode)
- **Secondary**: `Color.secondary` (adaptive)
- **Background**: `Color(.systemBackground)` (adaptive)
- **Text**: `Color.primary` / `Color.secondary` (adaptive)

### Typography
- **Headers**: System font, bold, 32pt max
- **Subheaders**: System font, medium, 20pt max
- **Body**: System font, regular, 17pt max
- **Captions**: System font, regular, 14pt max

### Components
- **Buttons**: Rounded corners (12pt), gradient backgrounds
- **Cards**: Rounded corners (16pt), subtle shadows
- **Input Fields**: Rounded corners (8pt), clear borders
- **Navigation**: Tab-based with icons

## 🔧 Technical Requirements

### Performance
- [ ] **App Launch Time**: < 3 seconds
- [ ] **Map Loading**: < 2 seconds
- [ ] **Search Response**: < 1 second
- [ ] **Memory Usage**: < 100MB average

### Security
- [ ] **Data Encryption**: All sensitive data encrypted
- [ ] **API Security**: Rate limiting and authentication
- [ ] **Privacy**: GDPR compliance
- [ ] **Secure Storage**: Keychain for sensitive data

### Accessibility
- [ ] **VoiceOver**: Full screen reader support
- [ ] **Dynamic Type**: Support for all text sizes
- [ ] **Color Contrast**: WCAG AA compliance
- [ ] **Motor Accessibility**: Large touch targets

## 📊 Success Metrics

### User Engagement
- **Daily Active Users**: Target 80% of registered users
- **Session Duration**: Average 10+ minutes
- **Feature Usage**: 70% of users use core features
- **Retention**: 60% monthly retention

### Performance
- **Crash Rate**: < 0.1%
- **Load Time**: < 3 seconds average
- **Search Success**: 95% successful searches
- **Navigation Accuracy**: 98% accurate directions

## 🗓️ Development Timeline

### Q1 2025: Foundation
- [x] Core app structure
- [x] Authentication system
- [x] Basic map functionality
- [x] User profiles

### Q2 2025: Enhancement
- [ ] Push notifications
- [ ] Advanced search
- [ ] Social features
- [ ] Performance optimization

### Q3 2025: Innovation
- [ ] AR navigation
- [ ] Indoor positioning
- [ ] Advanced analytics
- [ ] Accessibility features

### Q4 2025: Scale
- [ ] Multi-university support
- [ ] Advanced admin tools
- [ ] Performance monitoring
- [ ] User feedback integration

## 🐛 Known Issues & Technical Debt

### High Priority
- [ ] **Memory leaks** in map rendering
- [ ] **Slow initial load** of educational data
- [ ] **Inconsistent state** management in some views

### Medium Priority
- [ ] **Code duplication** in form components
- [ ] **Missing error handling** in network calls
- [ ] **Inconsistent naming** conventions

### Low Priority
- [ ] **Code documentation** needs improvement
- [ ] **Test coverage** is insufficient
- [ ] **Performance monitoring** needs implementation

## 📝 Notes & Ideas

### Future Considerations
- **Multi-language support** for international students
- **Offline mode** for basic functionality
- **Apple Watch app** for quick navigation
- **Siri integration** for voice commands
- **Widget support** for quick access to announcements

### Technical Improvements
- **SwiftUI migration** to latest features
- **Combine framework** for reactive programming
- **Core Data** for offline data persistence
- **CloudKit** for data synchronization

---

*Last Updated: 2025-09-07*
*Version: 1.0*
*Status: Active Development*
