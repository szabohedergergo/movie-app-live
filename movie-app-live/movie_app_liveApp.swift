import SwiftUI

@main
struct movie_app_liveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = AppTheme.light.rawValue
    
    var preferredSwiftUIScheme: ColorScheme {
        if colorSchemeRawValue == AppTheme.dark.rawValue {
            return .dark
        } else {
            return .light
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
                .preferredColorScheme(preferredSwiftUIScheme)
        }
    }
}
