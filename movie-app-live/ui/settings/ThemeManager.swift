// ThemeManager.swift
import Foundation
import SwiftUI

protocol ThemeManaging {
    var currentTheme: AppTheme { get }
    func setTheme(_ theme: AppTheme)
}

class AppThemeManager: ObservableObject, ThemeManaging {
    @AppStorage("color-scheme") private var colorSchemeRawValue: String = AppTheme.light.rawValue {
        didSet {
            //ha @AppStorage megváltoztatja a colorSchemeRawValue értékét
            let newThemeToSet = AppTheme(rawValue: colorSchemeRawValue) ?? .light
            if currentTheme != newThemeToSet {
                currentTheme = newThemeToSet
            }
        }
    }

    @Published var currentTheme: AppTheme = .light {
        didSet {
            if colorSchemeRawValue != currentTheme.rawValue {
                colorSchemeRawValue = currentTheme.rawValue
            }
        }
    }

    // Az init() metódus most már lehet üres, vagy el is hagyható,
    // mivel a property-knek van alapértelmezett értékük, és a @AppStorage elvégzi a betöltést.
    // Amikor az objektum létrejön:
    // 1. `currentTheme` kezdetben `.light` (az itt megadott default).
    // 2. `colorSchemeRawValue` megkapja az értékét az `AppStorage`-ból (pl. "dark" lehet, ha korábban az volt mentve).
    //    Ennek a `didSet`-je lefut.
    // 3. `colorSchemeRawValue.didSet` (ha az érték változott vagy az @AppStorage triggereli):
    //    Beállítja a `currentTheme`-et az `AppStorage`-ból olvasott értékre (pl. `.dark`).
    //    Ez kiváltja a `currentTheme.didSet`-jét.
    // 4. `currentTheme.didSet`:
    //    Ellenőrzi, hogy a `colorSchemeRawValue` (pl. "dark") egyezik-e a `currentTheme.rawValue` (pl. "dark") értékével.
    //    Ha egyeznek, nem csinál semmit, így elkerüljük a végtelen ciklust.
    // Ez a logika biztosítja, hogy az inicializálás helyes legyen és a property-k szinkronban maradjanak.
    init() {
    }

    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }

    var swiftUIColorScheme: ColorScheme {
        switch currentTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
