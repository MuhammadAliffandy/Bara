//
//  ShieldConfigurationExtension.swift
//  BaraShieldConf
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        
        // Warna sesuai sistem Bara
        let purple = UIColor(red: 0.42, green: 0.18, blue: 0.88, alpha: 1.0)
        let white = UIColor.white
        let softWhite = white.withAlphaComponent(0.75)
        
        // Ikon api khas Bara
        let fireIcon = UIImage(systemName: "flame.fill")?
            .withTintColor(.orange, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 60, weight: .bold))
        
        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: .black,
            
            icon: fireIcon,
            
            title: ShieldConfiguration.Label(
                text: "Ready for a break?",
                color: white
            ),
            
            subtitle: ShieldConfiguration.Label(
                text: "Tap the button to take a break",
                color: softWhite
            ),
            
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Next",
                color: .white
            ),
            primaryButtonBackgroundColor: purple
        )
    }
}
