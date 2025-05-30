import Foundation
import Combine

protocol SettingsViewModelProtocol: ObservableObject {
    var selectedLanguage: String { get }
    var selectedTheme: AppTheme { get }
    func changeSelectedLanguge(_ language: String)
    func changeTheme(_ theme: AppTheme)
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published var selectedLanguage: String
    @Published var selectedTheme: AppTheme

    private let userDefaults: UserDefaults
    private let themeKey = "color-scheme"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        // nyelv betoltese
        self.selectedLanguage = Bundle.getLangCode()

        // UserDefaultsbol tema betoltese
        let storedThemeRawValue = userDefaults.string(forKey: themeKey) ?? AppTheme.light.rawValue
        self.selectedTheme = AppTheme(rawValue: storedThemeRawValue) ?? .light

        if AppTheme(rawValue: storedThemeRawValue) == nil {
            userDefaults.set(AppTheme.light.rawValue, forKey: themeKey)
        }
    }

    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }

    func changeTheme(_ theme: AppTheme) {
        self.selectedTheme = theme
        userDefaults.set(theme.rawValue, forKey: themeKey) // Téma mentése UserDefaults-ba
    }
}
