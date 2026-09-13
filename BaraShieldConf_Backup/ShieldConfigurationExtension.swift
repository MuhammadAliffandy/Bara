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
        
        // Ikon api (mirip gambar fire di ScreenShieldView)
        let fireIcon = UIImage(systemName: "flame.fill")?
            .withTintColor(.orange, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 60, weight: .bold))
        
        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: .black,
            
            // Ikon api di tengah (pengganti Image(AppImage.ImageFireWork1))
            icon: fireIcon,
            
            // Judul (sama seperti title di ScreenShieldView)
            title: ShieldConfiguration.Label(
                text: "Ready for a break?",
                color: white
            ),
            
            // Subtitle (sama seperti subtitle di ScreenShieldView)
            subtitle: ShieldConfiguration.Label(
                text: "Set how long you'll rest and what you'll work on when you're back",
                color: softWhite
            ),
            
            // Tombol Utama (sama seperti AppButton "I wanna take break")
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I wanna take break",
                color: .white
            ),
            primaryButtonBackgroundColor: purple,
     
        )
    }
}
